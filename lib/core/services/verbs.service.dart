import 'package:cthulhu_solo_investigator_app/core/models/basic_roll.dart';
import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';

class VerbsService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();

  Future<VerbRoll> getVerbRoll() async {
    final List<BasicRoll> verbs = await getVerbs();
    final BasicRoll action = await getAction();
    final BasicRoll subject = await getSubjects();
    return VerbRoll(
      verb1: verbs[0].response,
      verb2: verbs[1].response,
      verb3: verbs[2].response,
      action: action.response,
      subject: subject.response,
      verb1Roll: verbs[0].roll,
      verb2Roll: verbs[1].roll,
      verb3Roll: verbs[2].roll,
      actionRoll: action.roll,
      subjectRoll: subject.roll,
    );
  }

  Future<List<BasicRoll>> getVerbs() async {
    final List<String> list = await _jsonService.getStringList('assets/data_base/verbs.json');
    final List<int> verbInts = _utilsService.getMultipleRandomInst(3, list.length);
    return [
      for (final i in verbInts) BasicRoll(response: list[i], roll: i),
    ];
  }

  Future<BasicRoll> getAction() async {
    final List<String> list =
        await _jsonService.getStringList('assets/data_base/verbs_actions.json');
    final int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }

  Future<BasicRoll> getSubjects() async {
    final List<String> list =
        await _jsonService.getStringList('assets/data_base/verbs_subjects.json');
    final int randomInt = _utilsService.getRandomInt(list.length);
    return BasicRoll(response: list[randomInt], roll: randomInt);
  }
}
