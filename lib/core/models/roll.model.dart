import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll_type.dart';
import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';

sealed class Roll {
  const Roll();

  RollType get type;
  Map<String, dynamic> toJson();

  factory Roll.fromJson(Map<String, dynamic> json) {
    final type = RollType.values.byName(json['type'] as String);
    final payload = json['payload'] as Map<String, dynamic>;
    return switch (type) {
      RollType.npc => NpcRoll(NPC.fromJson(payload)),
      RollType.verbs => VerbsRoll(VerbRoll.fromJson(payload)),
      RollType.direction => DirectionRollEntry(DirectionRoll.fromJson(payload)),
      RollType.clue => CluesRollEntry(CluesRoll.fromJson(payload)),
      RollType.question => QuestionRollEntry(QuestionRoll.fromJson(payload)),
      RollType.scene => SceneRollEntry(SceneRoll.fromJson(payload)),
    };
  }
}

Map<String, dynamic> _wrap(RollType type, Map<String, dynamic> payload) =>
    {'type': type.name, 'payload': payload};

class NpcRoll extends Roll {
  final NPC data;
  const NpcRoll(this.data);
  @override
  RollType get type => RollType.npc;
  @override
  Map<String, dynamic> toJson() => _wrap(type, data.toJson());
}

class VerbsRoll extends Roll {
  final VerbRoll data;
  const VerbsRoll(this.data);
  @override
  RollType get type => RollType.verbs;
  @override
  Map<String, dynamic> toJson() => _wrap(type, data.toJson());
}

class DirectionRollEntry extends Roll {
  final DirectionRoll data;
  const DirectionRollEntry(this.data);
  @override
  RollType get type => RollType.direction;
  @override
  Map<String, dynamic> toJson() => _wrap(type, data.toJson());
}

class CluesRollEntry extends Roll {
  final CluesRoll data;
  const CluesRollEntry(this.data);
  @override
  RollType get type => RollType.clue;
  @override
  Map<String, dynamic> toJson() => _wrap(type, data.toJson());
}

class QuestionRollEntry extends Roll {
  final QuestionRoll data;
  const QuestionRollEntry(this.data);
  @override
  RollType get type => RollType.question;
  @override
  Map<String, dynamic> toJson() => _wrap(type, data.toJson());
}

class SceneRollEntry extends Roll {
  final SceneRoll data;
  const SceneRollEntry(this.data);
  @override
  RollType get type => RollType.scene;
  @override
  Map<String, dynamic> toJson() => _wrap(type, data.toJson());
}
