import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/clues_card.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/direction_card.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/npc_card.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/question_card.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/scene_card.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/verbs_card.dart';
import 'package:flutter/material.dart';

class RollView extends StatelessWidget {
  final Roll roll;
  const RollView(this.roll, {super.key});

  @override
  Widget build(BuildContext context) {
    return switch (roll) {
      NpcRoll(:final data) => NPCCard(data),
      VerbsRoll(:final data) => VerbsCard(verbRoll: data),
      DirectionRollEntry(:final data) => DirectionCard(data),
      CluesRollEntry(:final data) => CluesCard(data),
      QuestionRollEntry(:final data) => QuestionCard(data),
      SceneRollEntry(:final data) => SceneCard(data),
    };
  }
}
