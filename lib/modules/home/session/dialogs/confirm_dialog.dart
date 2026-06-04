import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('CANCELAR',
              style: TextStyle(color: AppColors.parchmentDim)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('ACEPTAR'),
        ),
      ],
    ),
  );
}
