import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showNameCampaignDialog(
  BuildContext context, {
  required String title,
  required String actionLabel,
  String initial = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _NameDialog(title: title, actionLabel: actionLabel, initial: initial),
  );
}

class _NameDialog extends StatefulWidget {
  final String title;
  final String actionLabel;
  final String initial;
  const _NameDialog({
    required this.title,
    required this.actionLabel,
    required this.initial,
  });

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _input;

  @override
  void initState() {
    super.initState();
    _input = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _input.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _input,
        autofocus: true,
        style: const TextStyle(color: AppColors.parchment),
        decoration: const InputDecoration(labelText: 'Nombre de la partida'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCELAR', style: TextStyle(color: AppColors.parchmentDim)),
        ),
        ElevatedButton(onPressed: _submit, child: Text(widget.actionLabel.toUpperCase())),
      ],
    );
  }
}
