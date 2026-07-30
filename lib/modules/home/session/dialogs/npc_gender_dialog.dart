import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showNpcGenderDialog(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.surfaceSunken,
    barrierColor: const Color(0xB806070E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      side: BorderSide(color: AppColors.accent800, width: 1),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿A QUIÉN TE ENCUENTRAS?',
              style: TextStyle(
                color: AppColors.accent300,
                fontSize: 11,
                letterSpacing: 2.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _GenderButton('Mujer', ctx)),
                const SizedBox(width: 8),
                Expanded(child: _GenderButton('Hombre', ctx)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _GenderButton extends StatelessWidget {
  final String label;
  final BuildContext parentCtx;
  const _GenderButton(this.label, this.parentCtx);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.text,
          side: const BorderSide(color: Color(0xFF3A3C4A), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.4,
          ),
        ),
        onPressed: () => Navigator.of(parentCtx).pop(label),
        child: Text(label.toUpperCase()),
      ),
    );
  }
}
