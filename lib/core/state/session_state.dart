import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';

class SessionState {
  final List<Roll> rolls;
  final int mythsCounter;
  final bool loading;

  const SessionState({
    required this.rolls,
    required this.mythsCounter,
    required this.loading,
  });

  const SessionState.initial()
      : rolls = const [],
        mythsCounter = 0,
        loading = true;

  bool get isEmpty => rolls.isEmpty && mythsCounter == 0;

  SessionState copyWith({
    List<Roll>? rolls,
    int? mythsCounter,
    bool? loading,
  }) =>
      SessionState(
        rolls: rolls ?? this.rolls,
        mythsCounter: mythsCounter ?? this.mythsCounter,
        loading: loading ?? this.loading,
      );
}
