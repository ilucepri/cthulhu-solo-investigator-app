import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns.repository.dart';
import 'package:cthulhu_solo_investigator_app/core/services/clues.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/direction.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/npc.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/question.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/scene.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/verbs.service.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final campaignsRepositoryProvider =
    Provider<CampaignsRepository>((_) => CampaignsRepository());
final npcServiceProvider = Provider<NPCService>((_) => NPCService());
final directionServiceProvider = Provider<DirectionService>((_) => DirectionService());
final verbsServiceProvider = Provider<VerbsService>((_) => VerbsService());
final cluesServiceProvider = Provider<CluesService>((_) => CluesService());
final questionServiceProvider = Provider<QuestionService>((_) => QuestionService());
final sceneServiceProvider = Provider<SceneService>((_) => SceneService());

final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(SessionController.new);

class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() {
    Future.microtask(_restore);
    return const SessionState.initial();
  }

  CampaignsRepository get _repo => ref.read(campaignsRepositoryProvider);

  Future<void> _restore() async {
    final campaigns = await _repo.loadAll();
    final migrated = await _repo.migrateLegacyIfAny(now: DateTime.now());
    final all = [...campaigns, if (migrated != null) migrated];
    final storedActive = await _repo.loadActiveId();
    String? active = storedActive;
    if (active != null && !all.any((c) => c.id == active)) {
      active = null;
    }
    if (migrated != null) {
      await _repo.saveAll(all);
      if (active == null) {
        active = migrated.id;
        await _repo.setActiveId(active);
      }
    }
    state = SessionState(
      campaigns: all,
      activeId: active,
      addedSeq: 0,
      loading: false,
    );
  }

  Future<Campaign> createCampaign(String name) async {
    final now = DateTime.now();
    final campaign = Campaign.fresh(
      id: now.microsecondsSinceEpoch.toString(),
      name: name.trim().isEmpty ? 'Partida sin título' : name.trim(),
      now: now,
    );
    final next = [...state.campaigns, campaign];
    state = state.copyWith(campaigns: next, activeId: campaign.id);
    await _repo.saveAll(next);
    await _repo.setActiveId(campaign.id);
    return campaign;
  }

  Future<void> selectCampaign(String id) async {
    state = state.copyWith(
      activeId: id,
      campaigns: _touch(id, DateTime.now()),
      addedSeq: 0,
    );
    await _repo.saveAll(state.campaigns);
    await _repo.setActiveId(id);
  }

  Future<void> closeActive() async {
    state = state.copyWith(clearActive: true);
    await _repo.setActiveId(null);
  }

  Future<void> renameCampaign(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    final next = state.campaigns
        .map((c) => c.id == id ? c.copyWith(name: trimmed) : c)
        .toList();
    state = state.copyWith(campaigns: next);
    await _repo.saveAll(next);
  }

  Future<void> deleteCampaign(String id) async {
    final next = state.campaigns.where((c) => c.id != id).toList();
    final newActive = state.activeId == id ? null : state.activeId;
    state = state.copyWith(
      campaigns: next,
      activeId: newActive,
      clearActive: state.activeId == id,
    );
    await _repo.saveAll(next);
    if (state.activeId == null) await _repo.setActiveId(null);
  }

  List<Campaign> _touch(String id, DateTime when) {
    return state.campaigns
        .map((c) => c.id == id ? c.copyWith(lastPlayedAt: when) : c)
        .toList();
  }

  Future<void> _updateActive(Campaign Function(Campaign) transform,
      {bool bumpSeq = false}) async {
    final activeId = state.activeId;
    if (activeId == null) return;
    final next = state.campaigns
        .map((c) => c.id == activeId
            ? transform(c).copyWith(lastPlayedAt: DateTime.now())
            : c)
        .toList();
    state = state.copyWith(
      campaigns: next,
      addedSeq: bumpSeq ? state.addedSeq + 1 : state.addedSeq,
    );
    await _repo.saveAll(next);
  }

  Future<Roll> _addRoll(Roll roll) async {
    await _updateActive(
      (c) => c.copyWith(rolls: [...c.rolls, roll]),
      bumpSeq: true,
    );
    return roll;
  }

  Future<Roll> addNpc(String genderSelected) async {
    final NPC npc = await ref.read(npcServiceProvider).getNPCRoll(genderSelected);
    return _addRoll(NpcRoll(npc));
  }

  Future<Roll> addVerbs() async {
    final VerbRoll verbs = await ref.read(verbsServiceProvider).getVerbRoll();
    return _addRoll(VerbsRoll(verbs));
  }

  Future<Roll> addDirection() async {
    final DirectionRoll d = await ref
        .read(directionServiceProvider)
        .getDirectionRoll(state.mythsCounter);
    return _addRoll(DirectionRollEntry(d));
  }

  Future<Roll> addClue() async {
    final CluesRoll c = await ref.read(cluesServiceProvider).getCluesRoll();
    return _addRoll(CluesRollEntry(c));
  }

  Future<Roll> addScene() async {
    final SceneRoll s = await ref
        .read(sceneServiceProvider)
        .getSceneRoll(state.mythsCounter);
    return _addRoll(SceneRollEntry(s));
  }

  Future<Roll> addQuestion(String question, String likelihood) async {
    final QuestionRoll q = await ref
        .read(questionServiceProvider)
        .getQuestionRoll(question, likelihood);
    return _addRoll(QuestionRollEntry(q));
  }

  Future<void> bumpMyths(int delta) async {
    final current = state.mythsCounter;
    final next = (current + delta).clamp(0, 1 << 30);
    if (next == current) return;
    await _updateActive((c) => c.copyWith(mythsCounter: next));
  }

  Future<void> resetMyths() async {
    if (state.mythsCounter == 0) return;
    await _updateActive((c) => c.copyWith(mythsCounter: 0));
  }

  Future<void> setNotes(String value) async {
    if (state.notes == value) return;
    await _updateActive((c) => c.copyWith(notes: value));
  }

  Future<void> clearActiveContent() async {
    await _updateActive(
      (c) => c.copyWith(rolls: const [], mythsCounter: 0, notes: ''),
    );
  }
}
