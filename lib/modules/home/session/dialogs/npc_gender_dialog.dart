import 'package:flutter/material.dart';

const _genders = ['Hombre', 'Mujer', 'Random'];

Future<String?> showNpcGenderDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Elegir género'),
      actions: [
        for (final option in _genders)
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(option),
            child: Text(option.toUpperCase()),
          ),
      ],
    ),
  );
}
