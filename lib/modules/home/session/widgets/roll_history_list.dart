import 'dart:async';

import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RollHistoryList extends ConsumerStatefulWidget {
  const RollHistoryList({super.key});

  @override
  ConsumerState<RollHistoryList> createState() => _RollHistoryListState();
}

class _RollHistoryListState extends ConsumerState<RollHistoryList> {
  final ScrollController _scroll = ScrollController();
  Timer? _highlightTimer;
  bool _highlightTop = false;

  @override
  void dispose() {
    _highlightTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _flashNewest() {
    setState(() => _highlightTop = true);
    _highlightTimer?.cancel();
    _highlightTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _highlightTop = false);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionControllerProvider.select((s) => s.addedSeq), (_, __) {
      _flashNewest();
    });

    final rolls = ref.watch(sessionControllerProvider.select((s) => s.rolls));
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
      controller: _scroll,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: rolls.length,
      itemBuilder: (context, i) {
        final roll = rolls[rolls.length - 1 - i];
        final highlight = i == 0 && _highlightTop;
        return _HighlightWrap(active: highlight, child: RollView(roll));
      },
    );
  }
}

class _HighlightWrap extends StatelessWidget {
  final bool active;
  final Widget child;
  const _HighlightWrap({required this.active, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.mythos.withOpacity(0.55),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : const [],
      ),
      child: child,
    );
  }
}
