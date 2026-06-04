import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';

class CluesService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();

  Future<CluesRoll> getCluesRoll() async {
    final Clues clues = await getClues();
    final List<int> linkedCluesInts =
        _utilsService.getMultipleRandomInst(2, clues.linkedClues.length);
    return CluesRoll(
      solo: clues.solo[_utilsService.getRandomInt(clues.solo.length)],
      tome: clues.tome[_utilsService.getRandomInt(clues.tome.length)],
      roomItem: clues.roomItems[_utilsService.getRandomInt(clues.roomItems.length)],
      weirdClue1: clues.weirdClues1[_utilsService.getRandomInt(clues.weirdClues1.length)],
      weirdClue2: clues.weirdClues2[_utilsService.getRandomInt(clues.weirdClues2.length)],
      weirdClue3: clues.weirdClues3[_utilsService.getRandomInt(clues.weirdClues3.length)],
      linkedClue1: clues.linkedClues[linkedCluesInts[0]],
      linkedClue2: clues.linkedClues[linkedCluesInts[1]],
      paranormalClue:
          clues.paranormalClues[_utilsService.getRandomInt(clues.paranormalClues.length)],
    );
  }

  Future<Clues> getClues() async {
    final List<dynamic> jsonList =
        await _jsonService.getObjectList('assets/data_base/clues.json');
    final jsonData = jsonList.cast<Map<String, dynamic>>();
    return Clues.fromJson(jsonData);
  }
}
