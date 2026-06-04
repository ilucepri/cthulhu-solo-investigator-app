import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class QuestionDialogResult {
  final String question;
  final String likelihood;
  const QuestionDialogResult(this.question, this.likelihood);
}

const _likelihoods = [
  'Imposible',
  'Improbable',
  'Poco probable',
  'Posible',
  'Probable',
  'Alto probable',
  'Certeza',
];

Future<QuestionDialogResult?> showQuestionDialog(BuildContext context) {
  return showDialog<QuestionDialogResult>(
    context: context,
    builder: (ctx) => const _QuestionDialog(),
  );
}

class _QuestionDialog extends StatefulWidget {
  const _QuestionDialog();

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  final TextEditingController _questionInput = TextEditingController();
  String _selected = 'Posible';

  @override
  void dispose() {
    _questionInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Haz una pregunta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _questionInput,
            style: const TextStyle(color: AppColors.parchment),
            decoration: const InputDecoration(labelText: 'Escribe tu pregunta'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selected,
            dropdownColor: AppColors.surfaceRaised,
            style: const TextStyle(color: AppColors.parchment),
            onChanged: (v) {
              if (v != null) setState(() => _selected = v);
            },
            items: _likelihoods
                .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCELAR',
              style: TextStyle(color: AppColors.parchmentDim)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            QuestionDialogResult(_questionInput.text, _selected),
          ),
          child: const Text('CONSULTAR'),
        ),
      ],
    );
  }
}
