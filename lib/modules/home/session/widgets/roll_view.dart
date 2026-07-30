import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RollView extends ConsumerWidget {
  final Roll roll;
  final bool justAdded;

  const RollView({required this.roll, this.justAdded = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RollCard(
      content: _contentFor(roll),
      time: roll.createdAt,
      pinned: roll.pinned,
      justAdded: justAdded,
      onTogglePin: () =>
          ref.read(sessionControllerProvider.notifier).togglePin(roll.id),
    );
  }
}

RollCardContent _contentFor(Roll roll) {
  return switch (roll) {
    NpcRoll(:final data) => RollCardContent(
        kicker: 'PNJ',
        headline: data.fullName,
        subtitle: '${data.job} · ${data.adjective}',
      ),
    VerbsRoll(:final data) => RollCardContent(
        kicker: 'VERBOS',
        chips: [data.verb1, data.verb2, data.verb3],
        blocks: [
          CardBlock('ACCIÓN', data.action),
          CardBlock('SUJETO', data.subject),
        ],
      ),
    DirectionRollEntry(:final data) => _direction(data),
    QuestionRollEntry(:final data) => RollCardContent(
        kicker: 'PREGUNTA',
        headline: data.question,
        blocks: [
          CardBlock(
            'PROBABILIDAD',
            '${data.likelihood} (${data.roll} vs ${data.target})',
          ),
          CardBlock('RESPUESTA', data.answer),
        ],
      ),
    SceneRollEntry(:final data) => RollCardContent(
        kicker: 'ESCENA',
        blocks: [CardBlock(data.type.toUpperCase(), data.response)],
      ),
    CluesRollEntry(:final data) => RollCardContent(
        kicker: 'PISTAS',
        subtitle: 'Elige la que encaje con tu escena.',
        blocks: [
          CardBlock('TOMO DE MITOS', data.tome),
          CardBlock('OBJETO EN LA HABITACIÓN', data.roomItem),
          CardBlock('PISTA SIMPLE', data.solo),
          CardBlock('PISTAS ENLAZADAS', '${data.linkedClue1} / ${data.linkedClue2}'),
          CardBlock('PISTA RARA', data.weirdClue1),
        ],
      ),
  };
}

RollCardContent _direction(dynamic d) {
  final isRest = d.directionType == 'Descanso';
  final blocks = <CardBlock>[
    if (!isRest && d.directionSubTypeInfo != '')
      CardBlock('DETALLE', d.directionSubTypeInfo as String)
    else if (!isRest && d.directionSubSubType != '')
      CardBlock('DETALLE', d.directionSubSubType as String),
    if ((d.actionList as List).isNotEmpty)
      CardBlock(
        'VERBOS',
        (d.actionList as List)
            .map((a) => a.response as String)
            .join(', '),
      ),
  ];
  return RollCardContent(
    kicker: 'DIRECCIÓN DE LA HISTORIA',
    headline: d.directionType as String,
    subtitle: (d.directionTypeInfo as String).isNotEmpty
        ? d.directionTypeInfo as String
        : null,
    blocks: blocks.isEmpty ? null : blocks,
  );
}
