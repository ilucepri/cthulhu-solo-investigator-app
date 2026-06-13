import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/confirm_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/myths_increase_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MythsCounterBar extends ConsumerWidget {
  const MythsCounterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final controller = ref.read(sessionControllerProvider.notifier);
    final atZero = session.mythsCounter == 0;

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Restar 1',
            onPressed: atZero ? null : () => controller.bumpMyths(-1),
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.parchment,
          ),
          IconButton(
            tooltip: 'Resetear contador',
            onPressed: atZero
                ? null
                : () async {
                    final ok = await showConfirmDialog(
                      context,
                      title: 'Resetear contador',
                      body: '¿Volver el Contador de Mitos a 0?',
                    );
                    if (ok == true) await controller.resetMyths();
                  },
            icon: const Icon(Icons.restart_alt),
            color: AppColors.parchment,
          ),
          Expanded(
            child: Center(
              child: Text(
                'CONTADOR DE MITOS · ${session.mythsCounter}',
                style: const TextStyle(
                  color: AppColors.mythos,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Aumentar mitos',
            onPressed: () => showMythsIncreaseSheet(context),
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.parchment,
          ),
        ],
      ),
    );
  }
}
