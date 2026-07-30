import 'package:cthulhu_solo_investigator_app/core/models/myths_level.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MythsMeter extends ConsumerWidget {
  final VoidCallback onTap;
  const MythsMeter({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(sessionControllerProvider.select((s) => s.mythsCounter));
    final level = MythsLevel.forCounter(counter);
    final fill = (counter / 20).clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'MITOS',
                  style: TextStyle(
                    color: AppColors.dim,
                    fontSize: 10,
                    letterSpacing: 2.2,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  level.label,
                  style: TextStyle(
                    color: level.color,
                    fontSize: 13,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '$counter',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _bar(fill),
          ],
        ),
      ),
    );
  }

  Widget _bar(double fill) {
    return LayoutBuilder(
      builder: (_, c) {
        final w = c.maxWidth;
        return SizedBox(
          height: 3,
          child: Stack(
            children: [
              Container(color: const Color(0xFF252734)),
              FractionallySizedBox(
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent800, AppColors.accent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              _tick(w, 0.15),
              _tick(w, 0.40),
              _tick(w, 0.75),
            ],
          ),
        );
      },
    );
  }

  Widget _tick(double width, double pos) {
    return Positioned(
      left: width * pos,
      top: 0,
      bottom: 0,
      child: Container(width: 1, color: AppColors.bg),
    );
  }
}

class AmbientHalo extends ConsumerStatefulWidget {
  final Widget child;
  const AmbientHalo({required this.child, super.key});

  @override
  ConsumerState<AmbientHalo> createState() => _AmbientHaloState();
}

class _AmbientHaloState extends ConsumerState<AmbientHalo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathe;

  @override
  void initState() {
    super.initState();
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = MythsLevel.forCounter(
      ref.watch(sessionControllerProvider.select((s) => s.mythsCounter)),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _breathe,
              builder: (_, __) {
                final breathe = 0.55 + 0.45 * _breathe.value;
                return Opacity(
                  opacity: level.haloOpacity * breathe,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 0.9,
                        center: const Alignment(0, 0.9),
                        colors: [
                          AppColors.accent700,
                          AppColors.accent700.withOpacity(0),
                        ],
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
