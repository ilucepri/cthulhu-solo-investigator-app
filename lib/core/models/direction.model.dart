import 'package:cthulhu_solo_investigator_app/core/models/basic_roll.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';

class DirectionRoll {
  String directionType;
  String directionTypeInfo;
  int directionTypeRoll;
  String directionSubType;
  String directionSubTypeInfo;
  int directionSubTypeRoll;
  String directionSubSubType;
  int directionSubSubRoll;
  List<BasicRoll> actionList;
  NPC? npc;

  DirectionRoll({
    required this.directionTypeRoll,
    required this.directionSubTypeRoll,
    required this.directionSubSubRoll,
    required this.directionType,
    required this.directionTypeInfo,
    required this.directionSubType,
    required this.directionSubTypeInfo,
    required this.directionSubSubType,
    required this.actionList,
    this.npc,
  });

  Map<String, dynamic> toJson() => {
        'directionType': directionType,
        'directionTypeInfo': directionTypeInfo,
        'directionTypeRoll': directionTypeRoll,
        'directionSubType': directionSubType,
        'directionSubTypeInfo': directionSubTypeInfo,
        'directionSubTypeRoll': directionSubTypeRoll,
        'directionSubSubType': directionSubSubType,
        'directionSubSubRoll': directionSubSubRoll,
        'actionList': actionList.map((a) => a.toJson()).toList(),
        if (npc != null) 'npc': npc!.toJson(),
      };

  factory DirectionRoll.fromJson(Map<String, dynamic> json) => DirectionRoll(
        directionType: json['directionType'] as String,
        directionTypeInfo: json['directionTypeInfo'] as String,
        directionTypeRoll: json['directionTypeRoll'] as int,
        directionSubType: json['directionSubType'] as String,
        directionSubTypeInfo: json['directionSubTypeInfo'] as String,
        directionSubTypeRoll: json['directionSubTypeRoll'] as int,
        directionSubSubType: json['directionSubSubType'] as String,
        directionSubSubRoll: json['directionSubSubRoll'] as int,
        actionList: (json['actionList'] as List<dynamic>)
            .map((a) => BasicRoll.fromJson(a as Map<String, dynamic>))
            .toList(),
        npc: json['npc'] != null ? NPC.fromJson(json['npc'] as Map<String, dynamic>) : null,
      );
}
