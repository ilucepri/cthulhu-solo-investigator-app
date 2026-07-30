import 'package:cthulhu_solo_investigator_app/core/models/roll_type.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/npc_gender_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OracleBar extends ConsumerWidget {
  const OracleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.surface, width: 1)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00161826), AppColors.bg],
          stops: [0.0, 0.5],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 9),
            child: Row(
              children: [
                Text(
                  'CONSULTAR EL ORÁCULO',
                  style: TextStyle(
                    color: AppColors.faint,
                    fontSize: 9.5,
                    letterSpacing: 2.4,
                  ),
                ),
                SizedBox(width: 9),
                Expanded(child: _FadingRule()),
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: (MediaQuery.of(context).size.width - 40) / 3 / 52,
            children: RollType.values
                .map((rt) => _OracleButton(rt))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FadingRule extends StatelessWidget {
  const _FadingRule();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.line, Color(0x002F313E)],
          ),
        ),
      ),
    );
  }
}

class _OracleButton extends ConsumerWidget {
  final RollType rollType;
  const _OracleButton(this.rollType);

  Future<void> _trigger(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(sessionControllerProvider.notifier);
    switch (rollType) {
      case RollType.npc:
        final gender = await showNpcGenderDialog(context);
        if (gender != null) await controller.addNpc(gender);
      case RollType.verbs:
        await controller.addVerbs();
      case RollType.direction:
        await controller.addDirection();
      case RollType.clue:
        await controller.addClue();
      case RollType.scene:
        await controller.addScene();
      case RollType.question:
        final args = await showQuestionDialog(context);
        if (args != null) {
          await controller.addQuestion(args.question, args.likelihood);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.surfaceSunken,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _trigger(context, ref),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF3A3C4A), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(rollType.icon, size: 17, color: AppColors.accent400),
              const SizedBox(height: 5),
              Text(
                rollType.label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSoft,
                  fontSize: 9.5,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
