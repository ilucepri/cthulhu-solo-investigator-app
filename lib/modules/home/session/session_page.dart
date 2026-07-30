import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/confirm_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/myths_increase_sheet.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/notes_sheet.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/myths_meter.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/pinned_thread.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_buttons_grid.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SessionPage extends ConsumerWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider);
    final controller = ref.read(sessionControllerProvider.notifier);
    final active = state.active;
    if (active == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final expCode = _expCode(state.campaigns, active.id);
    final hasNotes = active.notes.trim().isNotEmpty;
    final canClear = active.rolls.isNotEmpty ||
        active.mythsCounter != 0 ||
        active.notes.isNotEmpty;

    return Scaffold(
      body: AmbientHalo(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _SessionHeader(
                code: expCode,
                name: active.name,
                hasNotes: hasNotes,
                canClear: canClear,
                onBack: () async {
                  await controller.closeActive();
                  if (context.mounted) Navigator.of(context).pop();
                },
                onNotes: () => showNotesSheet(context),
                onClear: () async {
                  final ok = await showConfirmDialog(
                    context,
                    title: 'Limpiar expediente',
                    body:
                        'Se borrarán las tiradas, el contador y las notas de este expediente. ¿Continuar?',
                    action: 'LIMPIAR',
                  );
                  if (ok == true) await controller.clearActiveContent();
                },
              ),
              MythsMeter(onTap: () => showMythsIncreaseSheet(context)),
              const PinnedThread(),
              const Expanded(child: RollFeed()),
              const OracleBar(),
            ],
          ),
        ),
      ),
    );
  }

  String _expCode(List campaigns, String id) {
    final sorted = [...campaigns]
      ..sort((a, b) => (a.createdAt as DateTime).compareTo(b.createdAt as DateTime));
    final index = sorted.indexWhere((c) => c.id == id);
    if (index < 0) return 'EXP-000';
    return 'EXP-${(index + 1).toString().padLeft(3, '0')}';
  }
}

class _SessionHeader extends StatelessWidget {
  final String code;
  final String name;
  final bool hasNotes;
  final bool canClear;
  final VoidCallback onBack;
  final VoidCallback onNotes;
  final VoidCallback onClear;

  const _SessionHeader({
    required this.code,
    required this.name,
    required this.hasNotes,
    required this.canClear,
    required this.onBack,
    required this.onNotes,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 44, 14, 0),
      child: Row(
        children: [
          _HeaderButton(
            icon: PhosphorIconsRegular.arrowLeft,
            iconSize: 19,
            onTap: onBack,
            tooltip: 'Volver',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: const TextStyle(
                      color: AppColors.dim,
                      fontSize: 9.5,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _HeaderButton(
            icon: PhosphorIconsRegular.notePencil,
            iconSize: 18,
            onTap: onNotes,
            dot: hasNotes,
            tooltip: 'Cuaderno',
          ),
          _HeaderButton(
            icon: PhosphorIconsRegular.eraser,
            iconSize: 18,
            onTap: canClear ? onClear : null,
            iconColor: AppColors.dim,
            tooltip: 'Limpiar expediente',
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback? onTap;
  final bool dot;
  final Color? iconColor;
  final String tooltip;

  const _HeaderButton({
    required this.icon,
    required this.iconSize,
    required this.onTap,
    required this.tooltip,
    this.dot = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          children: [
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onTap,
                  child: Center(
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: onTap == null
                          ? AppColors.faint
                          : (iconColor ?? const Color(0xFFB2B6CA)),
                    ),
                  ),
                ),
              ),
            ),
            if (dot)
              const Positioned(
                top: 6,
                right: 6,
                child: _AccentDot(),
              ),
          ],
        ),
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  const _AccentDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
    );
  }
}
