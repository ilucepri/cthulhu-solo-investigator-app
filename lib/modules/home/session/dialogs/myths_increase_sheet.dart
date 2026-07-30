import 'package:cthulhu_solo_investigator_app/core/objects/myths_counter.dart'
    as myths_list;
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showMythsIncreaseSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surfaceSunken,
    barrierColor: const Color(0xB806070E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      side: BorderSide(color: AppColors.accent800, width: 1),
    ),
    builder: (_) => const _MythsSheet(),
  );
}

class _MythsSheet extends ConsumerWidget {
  const _MythsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(sessionControllerProvider.notifier);
    final counter = ref.watch(sessionControllerProvider.select((s) => s.mythsCounter));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Expanded(
                  child: Text(
                    'CONTADOR DE MITOS',
                    style: TextStyle(
                      color: AppColors.accent300,
                      fontSize: 11,
                      letterSpacing: 2.4,
                    ),
                  ),
                ),
                Text(
                  '$counter',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StepButton(
                    label: '−1',
                    onTap: counter == 0 ? null : () => controller.bumpMyths(-1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StepButton(
                    label: '+1',
                    onTap: () => controller.bumpMyths(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StepButton(
                    label: 'RESET',
                    small: true,
                    onTap: counter == 0
                        ? null
                        : () async {
                            await controller.resetMyths();
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'PRESENCIAR ALGO…',
              style: TextStyle(
                color: AppColors.dim,
                fontSize: 9.5,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 6),
            for (final e in myths_list.mythsCounterList)
              _EventRow(
                event: e.event,
                sanity: e.sanityLoss,
                delta: e.counter,
                onTap: () {
                  controller.bumpMyths(e.counter);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool small;
  const _StepButton({required this.label, required this.onTap, this.small = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: small ? AppColors.muted : AppColors.text,
          disabledForegroundColor: AppColors.faint,
          side: const BorderSide(color: AppColors.lineStrong, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: small ? 11 : 15,
            fontWeight: FontWeight.w500,
            letterSpacing: small ? 1.8 : 0,
          ),
        ),
        child: Text(small ? label.toUpperCase() : label),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final String event;
  final String sanity;
  final int delta;
  final VoidCallback onTap;

  const _EventRow({
    required this.event,
    required this.sanity,
    required this.delta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lineSoft, width: 1)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event,
                      style: const TextStyle(color: AppColors.text, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cordura $sanity',
                      style: const TextStyle(
                        color: AppColors.dim,
                        fontSize: 11.5,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+$delta',
                style: const TextStyle(
                  color: AppColors.accent400,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
