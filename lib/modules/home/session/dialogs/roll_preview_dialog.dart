import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_view.dart';
import 'package:flutter/material.dart';

Future<void> showRollPreviewDialog(BuildContext context, Roll roll) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [RollView(roll)]),
      ),
    ),
  );
}
