import 'package:flutter/material.dart';

enum MythsLevel {
  calm(0, 2, 'CALMA', Color(0xFF75798C), 0.05),
  whispers(3, 7, 'SUSURROS', Color(0xFF9690C9), 0.14),
  presence(8, 14, 'PRESENCIA', Color(0xFFB5ABFC), 0.26),
  encirclement(15, 1 << 30, 'CERCO', Color(0xFFD2CEFD), 0.42);

  const MythsLevel(this.min, this.max, this.label, this.color, this.haloOpacity);
  final int min;
  final int max;
  final String label;
  final Color color;
  final double haloOpacity;

  static MythsLevel forCounter(int counter) {
    for (final level in MythsLevel.values) {
      if (counter <= level.max) return level;
    }
    return MythsLevel.encirclement;
  }
}
