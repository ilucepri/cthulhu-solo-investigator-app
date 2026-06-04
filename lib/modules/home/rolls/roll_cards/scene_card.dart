import 'package:cthulhu_solo_investigator_app/core/models/scene.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/roll_card_shell.dart';
import 'package:flutter/material.dart';

class SceneCard extends StatelessWidget {
  final SceneRoll sceneRoll;
  const SceneCard(this.sceneRoll, {super.key});

  @override
  Widget build(BuildContext context) {
    return RollCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle('Escenario · ${sceneRoll.type}'),
          CardBody(sceneRoll.response),
        ],
      ),
    );
  }
}
