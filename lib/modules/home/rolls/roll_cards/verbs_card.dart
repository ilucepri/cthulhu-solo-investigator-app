import 'package:cthulhu_solo_investigator_app/core/models/verbs.model.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/rolls/roll_cards/roll_card_shell.dart';
import 'package:flutter/material.dart';

class VerbsCard extends StatelessWidget {
  final VerbRoll verbRoll;
  const VerbsCard({required this.verbRoll, super.key});

  @override
  Widget build(BuildContext context) {
    return RollCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Verbos'),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
            child: Wrap(
              spacing: 12,
              children: [
                _verbChip(verbRoll.verb1),
                _verbChip(verbRoll.verb2),
                _verbChip(verbRoll.verb3),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _labeled('Acción', verbRoll.action),
                _labeled('Sujeto', verbRoll.subject),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verbChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.parchment, fontSize: 15),
      ),
    );
  }

  Widget _labeled(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.mythos,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Text(value, style: const TextStyle(color: AppColors.parchment, fontSize: 15)),
      ],
    );
  }
}
