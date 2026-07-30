import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  String action = 'ACEPTAR',
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: const Color(0xB806070E),
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      title: Text(title),
      content: Text(body),
      actionsPadding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.lineStrong, width: 1),
                  foregroundColor: AppColors.muted,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.4,
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('CANCELAR'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(action),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
