import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showNameCampaignDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
  required String hint,
  String initial = '',
}) {
  return showDialog<String>(
    context: context,
    barrierColor: const Color(0xB806070E),
    builder: (ctx) => _NameDialog(
      title: title,
      body: body,
      action: action,
      hint: hint,
      initial: initial,
    ),
  );
}

class _NameDialog extends StatefulWidget {
  final String title;
  final String body;
  final String action;
  final String hint;
  final String initial;
  const _NameDialog({
    required this.title,
    required this.body,
    required this.action,
    required this.hint,
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
    Navigator.of(context).pop(value.isEmpty ? 'Caso sin nombre' : value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.body),
          const SizedBox(height: 14),
          TextField(
            controller: _input,
            autofocus: true,
            style: const TextStyle(color: AppColors.text, fontSize: 15),
            cursorColor: AppColors.accent,
            decoration: InputDecoration(hintText: widget.hint),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCELAR'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(widget.action.toUpperCase()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
