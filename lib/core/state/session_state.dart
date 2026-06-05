import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';

class SessionState {
  final List<Campaign> campaigns;
  final String? activeId;
  final int addedSeq;
  final bool loading;

  const SessionState({
    required this.campaigns,
    required this.activeId,
    required this.addedSeq,
    required this.loading,
  });

  const SessionState.initial()
      : campaigns = const [],
        activeId = null,
        addedSeq = 0,
        loading = true;

  Campaign? get active {
    if (activeId == null) return null;
    for (final c in campaigns) {
      if (c.id == activeId) return c;
    }
    return null;
  }

  List<Roll> get rolls => active?.rolls ?? const [];
  int get mythsCounter => active?.mythsCounter ?? 0;
  String get notes => active?.notes ?? '';

  SessionState copyWith({
    List<Campaign>? campaigns,
    String? activeId,
    bool clearActive = false,
    int? addedSeq,
    bool? loading,
  }) =>
      SessionState(
        campaigns: campaigns ?? this.campaigns,
        activeId: clearActive ? null : (activeId ?? this.activeId),
        addedSeq: addedSeq ?? this.addedSeq,
        loading: loading ?? this.loading,
      );
}
