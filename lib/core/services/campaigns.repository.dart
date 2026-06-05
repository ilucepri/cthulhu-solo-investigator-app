import 'dart:convert';

import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignsRepository {
  static const _campaignsKey = 'campaigns.v1';
  static const _activeIdKey = 'campaigns.activeId.v1';

  static const _legacyRollsKey = 'session.rolls.v1';
  static const _legacyMythsKey = 'session.myths.v1';
  static const _legacyNotesKey = 'session.notes.v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<Campaign>> loadAll() async {
    final sp = await _prefs;
    final raw = sp.getString(_campaignsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list.map((j) => Campaign.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      await sp.remove(_campaignsKey);
      return [];
    }
  }

  Future<void> saveAll(List<Campaign> campaigns) async {
    final sp = await _prefs;
    final encoded = jsonEncode(campaigns.map((c) => c.toJson()).toList());
    await sp.setString(_campaignsKey, encoded);
  }

  Future<String?> loadActiveId() async {
    final sp = await _prefs;
    return sp.getString(_activeIdKey);
  }

  Future<void> setActiveId(String? id) async {
    final sp = await _prefs;
    if (id == null) {
      await sp.remove(_activeIdKey);
    } else {
      await sp.setString(_activeIdKey, id);
    }
  }

  Future<Campaign?> migrateLegacyIfAny({required DateTime now}) async {
    final sp = await _prefs;
    final hasLegacy = sp.containsKey(_legacyRollsKey) ||
        sp.containsKey(_legacyMythsKey) ||
        sp.containsKey(_legacyNotesKey);
    if (!hasLegacy) return null;

    List<Roll> rolls = const [];
    final rawRolls = sp.getString(_legacyRollsKey);
    if (rawRolls != null && rawRolls.isNotEmpty) {
      try {
        final list = jsonDecode(rawRolls) as List<dynamic>;
        rolls = list.map((j) => Roll.fromJson(j as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final myths = sp.getInt(_legacyMythsKey) ?? 0;
    final notes = sp.getString(_legacyNotesKey) ?? '';

    final migrated = Campaign(
      id: now.microsecondsSinceEpoch.toString(),
      name: 'Partida sin título',
      createdAt: now,
      lastPlayedAt: now,
      rolls: rolls,
      mythsCounter: myths,
      notes: notes,
    );

    await sp.remove(_legacyRollsKey);
    await sp.remove(_legacyMythsKey);
    await sp.remove(_legacyNotesKey);
    return migrated;
  }

  Future<void> wipeAll() async {
    final sp = await _prefs;
    await sp.remove(_campaignsKey);
    await sp.remove(_activeIdKey);
  }
}
