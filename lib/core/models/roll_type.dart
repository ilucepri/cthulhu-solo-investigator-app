import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum RollType {
  npc('PNJ'),
  verbs('Verbos'),
  direction('Dirección'),
  question('Pregunta'),
  scene('Escena'),
  clue('Pistas');

  const RollType(this.label);
  final String label;

  IconData get icon => switch (this) {
        RollType.npc => PhosphorIconsRegular.userFocus,
        RollType.verbs => PhosphorIconsRegular.quotes,
        RollType.direction => PhosphorIconsRegular.compass,
        RollType.question => PhosphorIconsRegular.question,
        RollType.scene => PhosphorIconsRegular.spiral,
        RollType.clue => PhosphorIconsRegular.magnifyingGlass,
      };

  String get kicker => switch (this) {
        RollType.npc => 'PNJ',
        RollType.verbs => 'VERBOS',
        RollType.direction => 'DIRECCIÓN DE LA HISTORIA',
        RollType.question => 'PREGUNTA',
        RollType.scene => 'ESCENA',
        RollType.clue => 'PISTAS',
      };
}
