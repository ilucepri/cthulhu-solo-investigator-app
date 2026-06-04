import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';

class QuestionService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();

  Future<QuestionRoll> getQuestionRoll(String question, String likelihood) async {
    final List<Odds> odds = await getOdds();
    final Odds oddSelected = odds.firstWhere((odd) => odd.title == likelihood);
    final int roll = _utilsService.getRandomInt(100) + oddSelected.odds;
    return QuestionRoll(
      question: question,
      likelihood: likelihood,
      roll: roll,
      answer: getAnswer(roll),
    );
  }

  Future<List<Odds>> getOdds() async {
    final List<dynamic> jsonList =
        await _jsonService.getObjectList('assets/data_base/odds.json');
    return jsonList.map((value) => Odds.fromJson(value)).toList();
  }

  String getAnswer(int roll) {
    if (roll <= 34) return "NO";
    if (roll <= 59) {
      return "QUIZÁS. Tira habilidad para comprobarlo o pregunta mejor. "
          "Si sale 2 QUIZÁS seguidos, tira verbos";
    }
    return "SÍ";
  }
}
