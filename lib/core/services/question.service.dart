import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';

class QuestionService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();

  Future<QuestionRoll> getQuestionRoll(String question, String likelihood) async {
    final List<Odds> odds = await getOdds();
    final Odds oddSelected = odds.firstWhere((odd) => odd.title == likelihood);
    final int roll = _utilsService.getRandomInt(100) + 1;
    final int target = 50 + oddSelected.odds;
    return QuestionRoll(
      question: question,
      likelihood: likelihood,
      roll: roll,
      target: target,
      answer: _answer(roll, target),
    );
  }

  Future<List<Odds>> getOdds() async {
    final List<dynamic> jsonList =
        await _jsonService.getObjectList('assets/data_base/odds.json');
    return jsonList.map((value) => Odds.fromJson(value)).toList();
  }

  String _answer(int roll, int target) {
    final low = target - 15 < 5 ? 5 : target - 15;
    if (roll <= low) return 'SÍ';
    if (roll > target + 15) return 'NO';
    return 'QUIZÁS. Tira habilidad para comprobarlo o pregunta mejor. '
        'Si sale 2 QUIZÁS seguidos, tira verbos';
  }
}
