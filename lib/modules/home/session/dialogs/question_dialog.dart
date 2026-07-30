import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class QuestionDialogResult {
  final String question;
  final String likelihood;
  const QuestionDialogResult(this.question, this.likelihood);
}

const List<String> _likelihoods = [
  'Imposible',
  'Improbable',
  'Poco probable',
  'Posible',
  'Probable',
  'Alto probable',
  'Certeza',
];

Future<QuestionDialogResult?> showQuestionDialog(BuildContext context) {
  return showModalBottomSheet<QuestionDialogResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surfaceSunken,
    barrierColor: const Color(0xB806070E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      side: BorderSide(color: AppColors.accent800, width: 1),
    ),
    builder: (ctx) => _QuestionSheet(),
  );
}

class _QuestionSheet extends StatefulWidget {
  @override
  State<_QuestionSheet> createState() => _QuestionSheetState();
}

class _QuestionSheetState extends State<_QuestionSheet> {
  final _input = TextEditingController();
  String _selected = 'Posible';

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PREGUNTA AL ORÁCULO',
                style: TextStyle(
                  color: AppColors.accent300,
                  fontSize: 11,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _input,
                autofocus: true,
                style: const TextStyle(color: AppColors.text, fontSize: 15),
                cursorColor: AppColors.accent,
                decoration: const InputDecoration(
                  hintText: '¿Hay alguien vigilando la casa?',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'PROBABILIDAD',
                style: TextStyle(
                  color: AppColors.dim,
                  fontSize: 10,
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: _likelihoods
                    .map((l) => _LikelihoodChip(
                          label: l,
                          selected: l == _selected,
                          onTap: () => setState(() => _selected = l),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_input.text.trim().isEmpty) return;
                    Navigator.of(context).pop(
                      QuestionDialogResult(_input.text.trim(), _selected),
                    );
                  },
                  child: const Text('CONSULTAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LikelihoodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LikelihoodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent.withOpacity(0.16) : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.lineStrong,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.accent300 : AppColors.muted,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }
}
