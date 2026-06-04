import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RollHistoryList extends ConsumerWidget {
  const RollHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolls = ref.watch(sessionControllerProvider).rolls;
    if (rolls.isEmpty) {
      return const Center(
        child: Text(
          'Aún no hay tiradas.\nQue los Antiguos lo permitan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.parchmentDim, fontSize: 15),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: rolls.length,
      itemBuilder: (context, i) => RollView(rolls[rolls.length - 1 - i]),
    );
  }
}
