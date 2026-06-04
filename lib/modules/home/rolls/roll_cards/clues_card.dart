import 'package:cthulhu_solo_investigator_app/core/models/clues.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/roll_card_shell.dart';
import 'package:flutter/material.dart';

class CluesCard extends StatelessWidget {
  final CluesRoll cluesRoll;
  const CluesCard(this.cluesRoll, {super.key});

  @override
  Widget build(BuildContext context) {
    return RollCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Tomo de mitos'),
          CardBody(cluesRoll.tome),
          const SizedBox(height: 8),
          const CardTitle('Objeto en la habitación'),
          CardBody(cluesRoll.roomItem),
          const SizedBox(height: 8),
          const CardTitle('Pista'),
          CardBody(cluesRoll.solo),
          const SizedBox(height: 8),
          const CardTitle('Pistas enlazadas'),
          CardBody(cluesRoll.linkedClue1),
          CardBody(cluesRoll.linkedClue2),
          const SizedBox(height: 8),
          const CardTitle('Pista rara I'),
          CardBody(cluesRoll.weirdClue1),
          const SizedBox(height: 8),
          const CardTitle('Pista rara II'),
          CardBody(cluesRoll.weirdClue2),
          const SizedBox(height: 8),
          const CardTitle('Pista rara III'),
          CardBody(cluesRoll.weirdClue3),
        ],
      ),
    );
  }
}
