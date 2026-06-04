import 'package:flutter/material.dart';

enum RollType {
  npc('NPC', Icons.face),
  verbs('Verbos', Icons.chat_bubble_outline),
  direction('Dirección', Icons.map),
  question('Pregunta', Icons.question_mark),
  scene('Escena', Icons.cyclone),
  clue('Pista', Icons.search);

  const RollType(this.label, this.icon);
  final String label;
  final IconData icon;
}
