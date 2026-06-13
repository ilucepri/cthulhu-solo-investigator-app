import 'package:cthulhu_solo_investigator_app/core/objects/myths_counter.dart'
    as myths_counter_list;
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showMythsIncreaseSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      side: BorderSide(color: AppColors.border),
    ),
    builder: (_) => const _MythsIncreaseSheet(),
  );
}

class _MythsIncreaseSheet extends ConsumerWidget {
  const _MythsIncreaseSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = myths_counter_list.mythsCounterList;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'AUMENTAR MITOS',
              style: TextStyle(
                color: AppColors.mythos,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          for (final e in entries)
            _MythsRow(
              label: e.event,
              delta: e.counter,
              onTap: () {
                ref.read(sessionControllerProvider.notifier).bumpMyths(e.counter);
                Navigator.of(context).pop();
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MythsRow extends StatelessWidget {
  final String label;
  final int delta;
  final VoidCallback onTap;

  const _MythsRow({required this.label, required this.delta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const sideWidth = 64.0;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: sideWidth),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.parchment,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            SizedBox(
              width: sideWidth,
              child: Text(
                '+$delta',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.mythos,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
