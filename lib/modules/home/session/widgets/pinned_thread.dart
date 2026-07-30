import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PinnedThread extends ConsumerWidget {
  const PinnedThread({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolls = ref.watch(sessionControllerProvider.select(
      (s) => s.rolls.where((r) => r.pinned).toList(),
    ));
    if (rolls.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 10),
      child: SizedBox(
        height: 30,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: rolls.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (_, i) => _chip(context, ref, rolls[i]),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, WidgetRef ref, Roll roll) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () =>
          ref.read(sessionControllerProvider.notifier).togglePin(roll.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        constraints: const BoxConstraints(maxWidth: 190),
        decoration: BoxDecoration(
          color: AppColors.accent800.withOpacity(0.28),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.accent800, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(PhosphorIconsFill.pushPin, size: 11, color: AppColors.accent300),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _label(roll),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.accent300,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(Roll roll) {
    return switch (roll) {
      NpcRoll(:final data) => data.fullName,
      DirectionRollEntry(:final data) => data.directionType,
      QuestionRollEntry(:final data) => data.question,
      SceneRollEntry(:final data) => data.response,
      VerbsRoll(:final data) => '${data.verb1} · ${data.verb2}',
      CluesRollEntry() => roll.type.kicker,
    };
  }
}
