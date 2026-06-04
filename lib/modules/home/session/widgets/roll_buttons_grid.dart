import 'package:cthulhu_solo_investigator_app/core/models/roll_type.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/npc_gender_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _historyTabIndex = 1;

class RollButtonsGrid extends ConsumerWidget {
  const RollButtonsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: RollType.values.map((rt) => _Button(rt)).toList(),
    );
  }
}

class _Button extends ConsumerWidget {
  final RollType rollType;
  const _Button(this.rollType);

  Future<bool> _trigger(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(sessionControllerProvider.notifier);
    switch (rollType) {
      case RollType.npc:
        final gender = await showNpcGenderDialog(context);
        if (gender == null) return false;
        await controller.addNpc(gender);
        return true;
      case RollType.verbs:
        await controller.addVerbs();
        return true;
      case RollType.direction:
        await controller.addDirection();
        return true;
      case RollType.clue:
        await controller.addClue();
        return true;
      case RollType.scene:
        await controller.addScene();
        return true;
      case RollType.question:
        final args = await showQuestionDialog(context);
        if (args == null) return false;
        await controller.addQuestion(args.question, args.likelihood);
        return true;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        final added = await _trigger(context, ref);
        if (added && context.mounted) {
          DefaultTabController.of(context).animateTo(_historyTabIndex);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(rollType.icon, size: 28, color: AppColors.mythos),
            const SizedBox(height: 8),
            Text(
              rollType.label.toUpperCase(),
              style: const TextStyle(
                color: AppColors.parchment,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
