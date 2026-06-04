import 'package:cthulhu_solo_investigator_app/core/models/basic_roll.dart';
import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';

class SceneService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();

  Future<SceneRoll> getSceneRoll(int mythsCounter) async {
    if (mythsCounter <= 33) {
      final scene = await _pick('assets/data_base/scenes_normal.json');
      return SceneRoll(type: 'Normal', response: scene.response, roll: scene.roll);
    } else if (mythsCounter <= 66) {
      final scene = await _pick('assets/data_base/scenes_gruesome.json');
      return SceneRoll(type: 'Turbia', response: scene.response, roll: scene.roll);
    } else {
      final scene = await _pick('assets/data_base/scenes_paranormal.json');
      return SceneRoll(type: 'Paranormal', response: scene.response, roll: scene.roll);
    }
  }

  Future<BasicRoll> _pick(String path) async {
    final list = await _jsonService.getStringList(path);
    final randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }
}
