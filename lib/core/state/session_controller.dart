import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/active_id_store.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/campaigns_repository.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/cloud_campaigns_repository.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/legacy_migrator.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/local_campaigns_repository.dart';
import 'package:cthulhu_solo_investigator_app/core/services/clues.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/direction.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/npc.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/question.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/scene.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/verbs.service.dart';
import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localCampaignsRepositoryProvider =
    Provider<LocalCampaignsRepository>((_) => LocalCampaignsRepository());
final cloudCampaignsRepositoryProvider =
    Provider<CloudCampaignsRepository>((_) => CloudCampaignsRepository());

final campaignsRepositoryProvider = Provider<CampaignsRepository>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return ref.watch(localCampaignsRepositoryProvider);
  return ref.watch(cloudCampaignsRepositoryProvider);
});

final activeIdStoreProvider = Provider<ActiveIdStore>((_) => ActiveIdStore());
final legacyMigratorProvider = Provider<LegacyMigrator>((_) => LegacyMigrator());

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
    ref.listen(authStateProvider, (prev, next) {
      final wasIn = prev?.valueOrNull != null;
      final isIn = next.valueOrNull != null;
      if (!wasIn && isIn) {
        Future.microtask(_onSignIn);
      } else if (wasIn && !isIn) {
        Future.microtask(_reload);
      }
    });
    Future.microtask(_restore);
    return const SessionState.initial();
  }

  CampaignsRepository get _repo => ref.read(campaignsRepositoryProvider);
  ActiveIdStore get _activeStore => ref.read(activeIdStoreProvider);
  LegacyMigrator get _migrator => ref.read(legacyMigratorProvider);

  Future<void> _restore() async {
    final loaded = await _repo.loadAll();
    final migrated = await _migrator.migrateIfAny(now: DateTime.now());
    final all = [...loaded, if (migrated != null) migrated];
    if (migrated != null) {
      await _repo.saveCampaign(migrated);
    }

    final storedActive = await _activeStore.load();
    String? active = storedActive;
    if (active != null && !all.any((c) => c.id == active)) active = null;
    if (migrated != null && active == null) {
      active = migrated.id;
      await _activeStore.set(active);
    }

    state = SessionState(
      campaigns: all,
      activeId: active,
      addedSeq: 0,
      loading: false,
    );
  }

  Future<void> _onSignIn() async {
    final local = ref.read(localCampaignsRepositoryProvider);
    final cloud = ref.read(cloudCampaignsRepositoryProvider);
    final localCampaigns = await local.loadAll();
    if (localCampaigns.isNotEmpty) {
      for (final c in localCampaigns) {
        await cloud.saveCampaign(c);
      }
      await local.wipeAll();
    }
    await _reload();
  }

  Future<void> _reload() async {
    state = state.copyWith(loading: true);
    await _restore();
  }

  Future<Campaign> createCampaign(String name) async {
    final now = DateTime.now();
    final campaign = Campaign.fresh(
      id: now.microsecondsSinceEpoch.toString(),
      name: name.trim().isEmpty ? 'Partida sin título' : name.trim(),
      now: now,
    );
    state = state.copyWith(
      campaigns: [...state.campaigns, campaign],
      activeId: campaign.id,
    );
    await _repo.saveCampaign(campaign);
    await _activeStore.set(campaign.id);
    return campaign;
  }

  Future<void> selectCampaign(String id) async {
    final now = DateTime.now();
    final next = state.campaigns
        .map((c) => c.id == id ? c.copyWith(lastPlayedAt: now) : c)
        .toList();
    state = state.copyWith(campaigns: next, activeId: id, addedSeq: 0);
    final touched = next.firstWhere((c) => c.id == id);
    await _repo.saveCampaign(touched);
    await _activeStore.set(id);
  }

  Future<void> closeActive() async {
    state = state.copyWith(clearActive: true);
    await _activeStore.set(null);
  }

  Future<void> renameCampaign(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    final next = state.campaigns
        .map((c) => c.id == id ? c.copyWith(name: trimmed) : c)
        .toList();
    state = state.copyWith(campaigns: next);
    final renamed = next.firstWhere((c) => c.id == id);
    await _repo.saveCampaign(renamed);
  }

  Future<void> deleteCampaign(String id) async {
    final next = state.campaigns.where((c) => c.id != id).toList();
    final becomingActiveless = state.activeId == id;
    state = state.copyWith(
      campaigns: next,
      activeId: becomingActiveless ? null : state.activeId,
      clearActive: becomingActiveless,
    );
    await _repo.deleteCampaign(id);
    if (becomingActiveless) await _activeStore.set(null);
  }

  Future<void> _updateActive(
    Campaign Function(Campaign) transform, {
    bool bumpSeq = false,
  }) async {
    final activeId = state.activeId;
    if (activeId == null) return;
    final now = DateTime.now();
    Campaign? updated;
    final next = state.campaigns.map((c) {
      if (c.id != activeId) return c;
      updated = transform(c).copyWith(lastPlayedAt: now);
      return updated!;
    }).toList();
    state = state.copyWith(
      campaigns: next,
      addedSeq: bumpSeq ? state.addedSeq + 1 : state.addedSeq,
    );
    if (updated != null) await _repo.saveCampaign(updated!);
  }

  ({String id, DateTime createdAt}) _newRollMeta() {
    final now = DateTime.now();
    return (id: 'roll-${now.microsecondsSinceEpoch}', createdAt: now);
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
    final m = _newRollMeta();
    return _addRoll(NpcRoll(id: m.id, createdAt: m.createdAt, data: npc));
  }

  Future<Roll> addVerbs() async {
    final VerbRoll verbs = await ref.read(verbsServiceProvider).getVerbRoll();
    final m = _newRollMeta();
    return _addRoll(VerbsRoll(id: m.id, createdAt: m.createdAt, data: verbs));
  }

  Future<Roll> addDirection() async {
    final DirectionRoll d = await ref
        .read(directionServiceProvider)
        .getDirectionRoll(state.mythsCounter);
    final m = _newRollMeta();
    return _addRoll(DirectionRollEntry(id: m.id, createdAt: m.createdAt, data: d));
  }

  Future<Roll> addClue() async {
    final CluesRoll c = await ref.read(cluesServiceProvider).getCluesRoll();
    final m = _newRollMeta();
    return _addRoll(CluesRollEntry(id: m.id, createdAt: m.createdAt, data: c));
  }

  Future<Roll> addScene() async {
    final SceneRoll s = await ref
        .read(sceneServiceProvider)
        .getSceneRoll(state.mythsCounter);
    final m = _newRollMeta();
    return _addRoll(SceneRollEntry(id: m.id, createdAt: m.createdAt, data: s));
  }

  Future<Roll> addQuestion(String question, String likelihood) async {
    final QuestionRoll q = await ref
        .read(questionServiceProvider)
        .getQuestionRoll(question, likelihood);
    final m = _newRollMeta();
    return _addRoll(QuestionRollEntry(id: m.id, createdAt: m.createdAt, data: q));
  }

  Future<void> togglePin(String rollId) async {
    await _updateActive((c) {
      final next = c.rolls
          .map((r) => r.id == rollId ? r.copyWith(pinned: !r.pinned) : r)
          .toList();
      return c.copyWith(rolls: next);
    });
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
