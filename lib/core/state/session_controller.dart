import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/clues.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/direction.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/npc.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/question.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/scene.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/session.repository.dart';
import 'package:cthulhu_solo_investigator_app/core/services/verbs.service.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((_) => SessionRepository());
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

  SessionRepository get _repo => ref.read(sessionRepositoryProvider);

  Future<void> _restore() async {
    final rolls = await _repo.loadRolls();
    final myths = await _repo.loadMythsCounter();
    final notes = await _repo.loadNotes();
    state = SessionState(
      rolls: rolls,
      mythsCounter: myths,
      notes: notes,
      addedSeq: 0,
      loading: false,
    );
  }

  Future<Roll> _addRoll(Roll roll) async {
    final newRolls = [...state.rolls, roll];
    state = state.copyWith(rolls: newRolls, addedSeq: state.addedSeq + 1);
    await _repo.saveRolls(newRolls);
    return roll;
  }

  Future<void> setNotes(String value) async {
    state = state.copyWith(notes: value);
    await _repo.saveNotes(value);
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
    final DirectionRoll d =
        await ref.read(directionServiceProvider).getDirectionRoll(state.mythsCounter);
    return _addRoll(DirectionRollEntry(d));
  }

  Future<Roll> addClue() async {
    final CluesRoll c = await ref.read(cluesServiceProvider).getCluesRoll();
    return _addRoll(CluesRollEntry(c));
  }

  Future<Roll> addScene() async {
    final SceneRoll s =
        await ref.read(sceneServiceProvider).getSceneRoll(state.mythsCounter);
    return _addRoll(SceneRollEntry(s));
  }

  Future<Roll> addQuestion(String question, String likelihood) async {
    final QuestionRoll q =
        await ref.read(questionServiceProvider).getQuestionRoll(question, likelihood);
    return _addRoll(QuestionRollEntry(q));
  }

  Future<void> bumpMyths(int delta) async {
    final next = (state.mythsCounter + delta).clamp(0, 1 << 30);
    state = state.copyWith(mythsCounter: next);
    await _repo.saveMythsCounter(next);
  }

  Future<void> resetMyths() async {
    state = state.copyWith(mythsCounter: 0);
    await _repo.saveMythsCounter(0);
  }

  Future<void> clearSession() async {
    state = state.copyWith(rolls: [], mythsCounter: 0, notes: '');
    await _repo.clear();
  }
}
