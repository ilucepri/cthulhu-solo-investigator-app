import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/roll_card_shell.dart';
import 'package:flutter/material.dart';

class NPCCard extends StatelessWidget {
  final NPC npcRoll;
  const NPCCard(this.npcRoll, {super.key});

  @override
  Widget build(BuildContext context) {
    return RollCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('NPC'),
          CardBody('${npcRoll.fullName} (${npcRoll.gender})'),
          CardBody('${npcRoll.job} · ${npcRoll.adjective}'),
        ],
      ),
    );
  }
}
