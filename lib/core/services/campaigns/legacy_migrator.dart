import 'dart:convert';

import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Migra las tres claves sueltas de la sesión monolítica anterior
/// (`session.rolls.v1`, `session.myths.v1`, `session.notes.v1`) a una
/// primera partida "Partida sin título". Idempotente: si no hay claves
/// legacy, devuelve null.
class LegacyMigrator {
  static const _rolls = 'session.rolls.v1';
  static const _myths = 'session.myths.v1';
  static const _notes = 'session.notes.v1';

  Future<Campaign?> migrateIfAny({required DateTime now}) async {
    final sp = await SharedPreferences.getInstance();
    final hasLegacy =
        sp.containsKey(_rolls) || sp.containsKey(_myths) || sp.containsKey(_notes);
    if (!hasLegacy) return null;

    List<Roll> rolls = const [];
    final rawRolls = sp.getString(_rolls);
    if (rawRolls != null && rawRolls.isNotEmpty) {
      try {
        final list = jsonDecode(rawRolls) as List<dynamic>;
        rolls = list.map((j) => Roll.fromJson(j as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final myths = sp.getInt(_myths) ?? 0;
    final notes = sp.getString(_notes) ?? '';

    await sp.remove(_rolls);
    await sp.remove(_myths);
    await sp.remove(_notes);

    return Campaign(
      id: now.microsecondsSinceEpoch.toString(),
      name: 'Partida sin título',
      createdAt: now,
      lastPlayedAt: now,
      rolls: rolls,
      mythsCounter: myths,
      notes: notes,
    );
  }
}
