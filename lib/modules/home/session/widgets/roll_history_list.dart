import 'dart:async';

import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RollFeed extends ConsumerStatefulWidget {
  const RollFeed({super.key});

  @override
  ConsumerState<RollFeed> createState() => _RollFeedState();
}

class _RollFeedState extends ConsumerState<RollFeed> {
  final ScrollController _scroll = ScrollController();
  String? _newestId;
  Timer? _clearTimer;

  @override
  void dispose() {
    _clearTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _markNewest(String id) {
    _clearTimer?.cancel();
    setState(() => _newestId = id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
    _clearTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) setState(() => _newestId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionControllerProvider.select((s) => s.addedSeq), (prev, next) {
      if (prev == null || next == prev) return;
      final rolls = ref.read(sessionControllerProvider).rolls;
      if (rolls.isNotEmpty) _markNewest(rolls.last.id);
    });

    final rolls = ref.watch(sessionControllerProvider.select((s) => s.rolls));
    if (rolls.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Aún no hay tiradas.\nQue los Antiguos lo permitan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.dim,
              fontSize: 14.5,
              height: 1.65,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 14),
      itemCount: rolls.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final roll = rolls[rolls.length - 1 - i];
        return RollView(roll: roll, justAdded: roll.id == _newestId);
      },
    );
  }
}
