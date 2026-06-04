import 'package:cthulhu_solo_investigator_app/core/models/direction.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/roll_card_shell.dart';
import 'package:flutter/material.dart';

class DirectionCard extends StatelessWidget {
  final DirectionRoll directionRoll;
  const DirectionCard(this.directionRoll, {super.key});

  @override
  Widget build(BuildContext context) {
    final responses = directionRoll.actionList.map((o) => o.response).toList();
    return RollCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Dirección de la historia'),
          CardBody(directionRoll.directionType),
          if (directionRoll.directionTypeInfo.isNotEmpty) ...[
            CardBody(directionRoll.directionTypeInfo),
            const SizedBox(height: 8),
          ],
          if (directionRoll.directionSubType.isNotEmpty)
            CardTitle(directionRoll.directionSubType),
          if (directionRoll.directionSubTypeInfo.isNotEmpty) ...[
            CardBody(directionRoll.directionSubTypeInfo),
            const SizedBox(height: 8),
          ],
          if (directionRoll.directionSubSubType.isNotEmpty)
            CardBody(directionRoll.directionSubSubType),
          if (directionRoll.actionList.isNotEmpty) ...[
            const CardTitle('Verbos'),
            CardBody(responses.join(', ')),
          ],
        ],
      ),
    );
  }
}
