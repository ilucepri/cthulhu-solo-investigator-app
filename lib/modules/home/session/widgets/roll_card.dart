import 'dart:async';

import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CardBlock {
  final String label;
  final String text;
  const CardBlock(this.label, this.text);
}

class RollCardContent {
  final String kicker;
  final String? headline;
  final String? subtitle;
  final List<String>? chips;
  final List<CardBlock>? blocks;

  const RollCardContent({
    required this.kicker,
    this.headline,
    this.subtitle,
    this.chips,
    this.blocks,
  });
}

class RollCard extends StatefulWidget {
  final RollCardContent content;
  final DateTime time;
  final bool pinned;
  final bool justAdded;
  final VoidCallback onTogglePin;

  const RollCard({
    required this.content,
    required this.time,
    required this.pinned,
    required this.justAdded,
    required this.onTogglePin,
    super.key,
  });

  @override
  State<RollCard> createState() => _RollCardState();
}

class _RollCardState extends State<RollCard> with SingleTickerProviderStateMixin {
  late final AnimationController _riseIn;
  Timer? _glowTimer;
  bool _glowing = false;

  @override
  void initState() {
    super.initState();
    _riseIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..forward();
    if (widget.justAdded) {
      _glowing = true;
      _glowTimer = Timer(const Duration(milliseconds: 2400), () {
        if (mounted) setState(() => _glowing = false);
      });
    }
  }

  @override
  void didUpdateWidget(covariant RollCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.justAdded && !oldWidget.justAdded) {
      setState(() => _glowing = true);
      _glowTimer?.cancel();
      _glowTimer = Timer(const Duration(milliseconds: 2400), () {
        if (mounted) setState(() => _glowing = false);
      });
    }
  }

  @override
  void dispose() {
    _glowTimer?.cancel();
    _riseIn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _riseIn,
      builder: (_, child) {
        final t = Curves.easeOut.transform(_riseIn.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - t)),
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _glowing ? AppColors.accent : AppColors.line,
            width: 1,
          ),
          boxShadow: _glowing
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.45),
                    blurRadius: 22,
                  ),
                ]
              : const [],
        ),
        padding: const EdgeInsets.fromLTRB(15, 14, 12, 15),
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final content = widget.content;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        if (content.headline != null) ...[
          const SizedBox(height: 9),
          Text(
            content.headline!,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.25,
              letterSpacing: -0.2,
            ),
          ),
        ],
        if (content.subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            content.subtitle!,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
        ],
        if (content.chips != null && content.chips!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: content.chips!.map(_chip).toList(),
          ),
        ],
        if (content.blocks != null && content.blocks!.isNotEmpty) ...[
          const SizedBox(height: 13),
          for (int i = 0; i < content.blocks!.length; i++) ...[
            if (i > 0) const SizedBox(height: 11),
            _block(content.blocks![i]),
          ],
        ],
      ],
    );
  }

  Widget _header() {
    final hours = widget.time.hour.toString().padLeft(2, '0');
    final mins = widget.time.minute.toString().padLeft(2, '0');
    return Row(
      children: [
        Container(
          width: 14,
          height: 2,
          color: AppColors.accent,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.content.kicker,
            style: const TextStyle(
              color: AppColors.accent300,
              fontSize: 10,
              letterSpacing: 2.0,
            ),
          ),
        ),
        Text(
          '$hours:$mins',
          style: const TextStyle(
            color: AppColors.dim,
            fontSize: 10.5,
            letterSpacing: 0.8,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(
          width: 28,
          height: 28,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: widget.onTogglePin,
            iconSize: 15,
            icon: Icon(
              widget.pinned
                  ? PhosphorIconsFill.pushPin
                  : PhosphorIconsRegular.pushPin,
              color: widget.pinned ? AppColors.accent400 : AppColors.faint,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceSunken,
        border: Border.all(color: AppColors.lineStrong, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.text, fontSize: 13.5),
      ),
    );
  }

  Widget _block(CardBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.label,
          style: const TextStyle(
            color: AppColors.dim,
            fontSize: 9.5,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          block.text,
          style: const TextStyle(
            color: AppColors.textSoft,
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
