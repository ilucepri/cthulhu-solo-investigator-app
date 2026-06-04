import 'package:cthulhu_solo_investigator_app/core/objects/myths_counter.dart'
    as myths_counter_list;
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MythsFab extends ConsumerStatefulWidget {
  const MythsFab({super.key});

  @override
  ConsumerState<MythsFab> createState() => _MythsFabState();
}

class _MythsFabState extends ConsumerState<MythsFab> {
  final GlobalKey<ExpandableFabState> _fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: _fabKey,
      distance: 80.0,
      type: ExpandableFabType.up,
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 56,
        builder: (context, onPressed, progress) => IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.close, size: 32, color: AppColors.parchment),
        ),
      ),
      overlayStyle: ExpandableFabOverlayStyle(blur: 4),
      children: myths_counter_list.mythsCounterList
          .map((counter) => FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: AppColors.surfaceRaised,
                foregroundColor: AppColors.parchment,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.border, width: 1),
                ),
                label: Text(
                  '${counter.event}  +${counter.counter}',
                  style: const TextStyle(
                    color: AppColors.parchment,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                onPressed: () {
                  ref
                      .read(sessionControllerProvider.notifier)
                      .bumpMyths(counter.counter);
                  _fabKey.currentState?.toggle();
                },
              ))
          .toList(),
    );
  }
}
