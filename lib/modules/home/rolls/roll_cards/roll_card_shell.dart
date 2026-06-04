import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RollCardShell extends StatelessWidget {
  final Widget child;
  const RollCardShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: child,
    );
  }
}

class CardTitle extends StatelessWidget {
  final String text;
  const CardTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.mythos,
            fontSize: 15,
          ),
    );
  }
}

class CardBody extends StatelessWidget {
  final String text;
  const CardBody(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 2, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.parchment, fontSize: 16, height: 1.35),
      ),
    );
  }
}
