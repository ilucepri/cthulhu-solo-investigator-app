import 'package:cthulhu_solo_investigator_app/core/constants/directions.dart';
import 'package:cthulhu_solo_investigator_app/core/models/basic_roll.dart';
import 'package:cthulhu_solo_investigator_app/core/models/development.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/npc.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/verbs.service.dart';

class DirectionService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();
  final VerbsService _verbsService = VerbsService();
  final NPCService _npcService = NPCService();

  int _rollD100(int mythsCounter) {
    final raw = _utilsService.getRandomInt(100) + 1 + mythsCounter;
    return raw.clamp(1, 100);
  }

  Future<DirectionRoll> getDirectionRoll(int mythsCounter) async {
    BasicRoll directionType = await getDirection(mythsCounter);
    String directionTypeInfo = "";
    BasicRoll? directionSubType;
    String directionSubTypeInfo = "";
    BasicRoll? directionSubSubType;
    List<BasicRoll> actionList = [];
    NPC? npc;
    if (directionType.response == Directions.typeRest) {
      directionSubType = await getDisturbance(mythsCounter);
      if (directionSubType.response == Directions.disturbanceSenses) {
        actionList = await _verbsService.getVerbs();
      } else if (directionSubType.response == Directions.disturbanceEvent) {
        directionSubSubType = await getDisturbanceEvent();
        actionList = await getDisturbanceEvents(directionSubSubType.response, mythsCounter);
      }
    } else if (directionType.response == Directions.typeDevelopment) {
      DevelopmentRoll devRoll = await getDevelopment(mythsCounter);
      directionSubType = BasicRoll(response: devRoll.type, roll: devRoll.roll);
      directionSubTypeInfo = devRoll.text;
      if (devRoll.type == "RANDOM") {
        actionList.add(await getRandom(mythsCounter));
      } else if (devRoll.type == "VERBS") {
        actionList = await _verbsService.getVerbs();
      } else if (devRoll.type == "NPC") {
        npc = await _npcService.getNPCRoll('Random');
      }
    } else if (directionType.response == Directions.typeDiscovery) {
      DevelopmentRoll devRoll = await getDiscovery();
      directionSubType = BasicRoll(response: devRoll.type, roll: devRoll.roll);
      directionSubTypeInfo = devRoll.text;
      if (directionSubTypeInfo.contains("Rumor")) {
        actionList.add(await getRumour());
      }
    } else if (directionType.response == Directions.typeDanger) {
      BasicRoll danger = await getDanger();
      directionTypeInfo = '(${danger.roll}) ${danger.response}';
      actionList = await _verbsService.getVerbs();
    } else if (directionType.response == Directions.typeEvent) {
      directionSubType = BasicRoll(response: Directions.disturbanceEvent, roll: 0);
      directionSubSubType = await getDisturbanceEvent();
      actionList = await getDisturbanceEvents(directionSubSubType.response, mythsCounter);
    }
    return DirectionRoll(
      directionType: directionType.response,
      directionTypeInfo: directionTypeInfo,
      directionSubType: directionSubType?.response ?? "",
      directionSubTypeInfo: directionSubTypeInfo,
      directionSubSubType: directionSubSubType?.response ?? "",
      actionList: actionList,
      directionTypeRoll: directionType.roll,
      directionSubTypeRoll: directionSubType?.roll ?? -1,
      directionSubSubRoll: directionSubSubType?.roll ?? -1,
      npc: npc,
    );
  }

  Future<List<BasicRoll>> getDisturbanceEvents(String directionSubSubType, int mythsCounter) async {
    List<BasicRoll> actionList = [];
    if (directionSubSubType == Directions.eventHear) {
      actionList.add(await getAuditory());
      actionList.add(await getAuditoryWhere());
    } else if (directionSubSubType == Directions.eventSee) {
      actionList.add(await getVisual(mythsCounter));
    } else if (directionSubSubType == Directions.eventEventful) {
      actionList.add(await getRandom(mythsCounter));
    }
    return actionList;
  }

  Future<BasicRoll> getDirection(int mythsCounter) async {
    List<String> list = await _jsonService.getStringList('assets/data_base/direction.json');
    final roll = _rollD100(mythsCounter);
    final int index = switch (roll) {
      <= 20 => 0,
      <= 40 => 1,
      <= 60 => 2,
      <= 80 => 3,
      _ => 4,
    };
    return BasicRoll(response: list[index], roll: roll);
  }

  Future<BasicRoll> getDisturbance(int mythsCounter) async {
    List<String> list = await _jsonService.getStringList('assets/data_base/disturbance.json');
    final roll = _rollD100(mythsCounter);
    final int index = switch (roll) {
      <= 30 => 0,
      <= 60 => 1,
      _ => 2,
    };
    return BasicRoll(response: list[index], roll: roll);
  }

  Future<BasicRoll> getDisturbanceEvent() async {
    List<String> list = await _jsonService.getStringList('assets/data_base/disturbance_event.json');
    int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }

  Future<BasicRoll> getAuditory() async {
    List<String> list = await _jsonService.getStringList('assets/data_base/event_auditory.json');
    int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }

  Future<BasicRoll> getAuditoryWhere() async {
    List<String> list = await _jsonService.getStringList('assets/data_base/event_auditory_where.json');
    int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }

  Future<BasicRoll> getVisual(int mythsCounter) async {
    List<String> list = await _jsonService.getStringList('assets/data_base/event_visual.json');
    final roll = _rollD100(mythsCounter);
    final int index = ((roll - 1) ~/ 4).clamp(0, list.length - 1);
    return BasicRoll(response: list[index], roll: roll);
  }

  Future<BasicRoll> getRandom(int mythsCounter) async {
    List<String> list = await _jsonService.getStringList('assets/data_base/event_random.json');
    final roll = _rollD100(mythsCounter);
    final int index = ((roll - 1) * list.length ~/ 100).clamp(0, list.length - 1);
    return BasicRoll(response: list[index], roll: roll);
  }

  Future<BasicRoll> getRumour() async {
    List<String> list = await _jsonService.getStringList('assets/data_base/rumour.json');
    int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }

  Future<BasicRoll> getDanger() async {
    List<String> list = await _jsonService.getStringList('assets/data_base/danger.json');
    int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }

  Future<DevelopmentRoll> getDevelopment(int mythsCounter) async {
    List<dynamic> jsonList = await _jsonService.getObjectList('assets/data_base/development.json');
    List<DevelopmentRoll> dataList =
        jsonList.map((value) => DevelopmentRoll.fromJson(value)).toList();
    final int index =
        (_utilsService.getRandomInt(dataList.length) + mythsCounter).clamp(0, dataList.length - 1);
    return dataList[index];
  }

  Future<DevelopmentRoll> getDiscovery() async {
    List<dynamic> jsonList = await _jsonService.getObjectList('assets/data_base/discovery.json');
    List<DevelopmentRoll> dataList =
        jsonList.map((value) => DevelopmentRoll.fromJson(value)).toList();
    int randomInt = _utilsService.getRandomInt(dataList.length);
    return dataList[randomInt];
  }
}
