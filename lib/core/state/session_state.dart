import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';

class SessionState {
  final List<Roll> rolls;
  final int mythsCounter;
  final String notes;
  final int addedSeq;
  final bool loading;

  const SessionState({
    required this.rolls,
    required this.mythsCounter,
    required this.notes,
    required this.addedSeq,
    required this.loading,
  });

  const SessionState.initial()
      : rolls = const [],
        mythsCounter = 0,
        notes = '',
        addedSeq = 0,
        loading = true;

  bool get isEmpty => rolls.isEmpty && mythsCounter == 0 && notes.isEmpty;

  SessionState copyWith({
    List<Roll>? rolls,
    int? mythsCounter,
    String? notes,
    int? addedSeq,
    bool? loading,
  }) =>
      SessionState(
        rolls: rolls ?? this.rolls,
        mythsCounter: mythsCounter ?? this.mythsCounter,
        notes: notes ?? this.notes,
        addedSeq: addedSeq ?? this.addedSeq,
        loading: loading ?? this.loading,
      );
}
