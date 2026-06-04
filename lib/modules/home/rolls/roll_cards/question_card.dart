import 'package:cthulhu_solo_investigator_app/core/models/odds.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/roll_card_shell.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final QuestionRoll questionRoll;
  const QuestionCard(this.questionRoll, {super.key});

  @override
  Widget build(BuildContext context) {
    return RollCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Pregunta'),
          CardBody(questionRoll.question),
          const SizedBox(height: 8),
          const CardTitle('Probabilidad'),
          CardBody(questionRoll.likelihood),
          const SizedBox(height: 8),
          const CardTitle('Respuesta'),
          CardBody(questionRoll.answer),
        ],
      ),
    );
  }
}
