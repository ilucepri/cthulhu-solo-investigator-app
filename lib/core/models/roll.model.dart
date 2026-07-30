import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll_type.dart';
import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';

sealed class Roll {
  final String id;
  final DateTime createdAt;
  final bool pinned;
  const Roll({required this.id, required this.createdAt, this.pinned = false});

  RollType get type;
  Roll copyWith({bool? pinned});
  Map<String, dynamic> toJson();

  factory Roll.fromJson(Map<String, dynamic> json) {
    final type = RollType.values.byName(json['type'] as String);
    final payload = json['payload'] as Map<String, dynamic>;
    final id = json['id'] as String? ?? _fallbackId();
    final createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.fromMillisecondsSinceEpoch(0);
    final pinned = json['pinned'] as bool? ?? false;
    return switch (type) {
      RollType.npc => NpcRoll(
          id: id,
          createdAt: createdAt,
          pinned: pinned,
          data: NPC.fromJson(payload),
        ),
      RollType.verbs => VerbsRoll(
          id: id,
          createdAt: createdAt,
          pinned: pinned,
          data: VerbRoll.fromJson(payload),
        ),
      RollType.direction => DirectionRollEntry(
          id: id,
          createdAt: createdAt,
          pinned: pinned,
          data: DirectionRoll.fromJson(payload),
        ),
      RollType.clue => CluesRollEntry(
          id: id,
          createdAt: createdAt,
          pinned: pinned,
          data: CluesRoll.fromJson(payload),
        ),
      RollType.question => QuestionRollEntry(
          id: id,
          createdAt: createdAt,
          pinned: pinned,
          data: QuestionRoll.fromJson(payload),
        ),
      RollType.scene => SceneRollEntry(
          id: id,
          createdAt: createdAt,
          pinned: pinned,
          data: SceneRoll.fromJson(payload),
        ),
    };
  }
}

Map<String, dynamic> _wrap(Roll roll, Map<String, dynamic> payload) => {
      'id': roll.id,
      'createdAt': roll.createdAt.toIso8601String(),
      'pinned': roll.pinned,
      'type': roll.type.name,
      'payload': payload,
    };

String _fallbackId() =>
    'roll-${DateTime.now().microsecondsSinceEpoch}';

class NpcRoll extends Roll {
  final NPC data;
  const NpcRoll({
    required super.id,
    required super.createdAt,
    required this.data,
    super.pinned,
  });
  @override
  RollType get type => RollType.npc;
  @override
  Roll copyWith({bool? pinned}) =>
      NpcRoll(id: id, createdAt: createdAt, data: data, pinned: pinned ?? this.pinned);
  @override
  Map<String, dynamic> toJson() => _wrap(this, data.toJson());
}

class VerbsRoll extends Roll {
  final VerbRoll data;
  const VerbsRoll({
    required super.id,
    required super.createdAt,
    required this.data,
    super.pinned,
  });
  @override
  RollType get type => RollType.verbs;
  @override
  Roll copyWith({bool? pinned}) =>
      VerbsRoll(id: id, createdAt: createdAt, data: data, pinned: pinned ?? this.pinned);
  @override
  Map<String, dynamic> toJson() => _wrap(this, data.toJson());
}

class DirectionRollEntry extends Roll {
  final DirectionRoll data;
  const DirectionRollEntry({
    required super.id,
    required super.createdAt,
    required this.data,
    super.pinned,
  });
  @override
  RollType get type => RollType.direction;
  @override
  Roll copyWith({bool? pinned}) => DirectionRollEntry(
      id: id, createdAt: createdAt, data: data, pinned: pinned ?? this.pinned);
  @override
  Map<String, dynamic> toJson() => _wrap(this, data.toJson());
}

class CluesRollEntry extends Roll {
  final CluesRoll data;
  const CluesRollEntry({
    required super.id,
    required super.createdAt,
    required this.data,
    super.pinned,
  });
  @override
  RollType get type => RollType.clue;
  @override
  Roll copyWith({bool? pinned}) => CluesRollEntry(
      id: id, createdAt: createdAt, data: data, pinned: pinned ?? this.pinned);
  @override
  Map<String, dynamic> toJson() => _wrap(this, data.toJson());
}

class QuestionRollEntry extends Roll {
  final QuestionRoll data;
  const QuestionRollEntry({
    required super.id,
    required super.createdAt,
    required this.data,
    super.pinned,
  });
  @override
  RollType get type => RollType.question;
  @override
  Roll copyWith({bool? pinned}) => QuestionRollEntry(
      id: id, createdAt: createdAt, data: data, pinned: pinned ?? this.pinned);
  @override
  Map<String, dynamic> toJson() => _wrap(this, data.toJson());
}

class SceneRollEntry extends Roll {
  final SceneRoll data;
  const SceneRollEntry({
    required super.id,
    required super.createdAt,
    required this.data,
    super.pinned,
  });
  @override
  RollType get type => RollType.scene;
  @override
  Roll copyWith({bool? pinned}) => SceneRollEntry(
      id: id, createdAt: createdAt, data: data, pinned: pinned ?? this.pinned);
  @override
  Map<String, dynamic> toJson() => _wrap(this, data.toJson());
}
