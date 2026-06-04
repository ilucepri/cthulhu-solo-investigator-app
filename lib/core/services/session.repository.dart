import 'dart:convert';

import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionRepository {
  static const _rollsKey = 'session.rolls.v1';
  static const _mythsKey = 'session.myths.v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<Roll>> loadRolls() async {
    final sp = await _prefs;
    final raw = sp.getString(_rollsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list.map((j) => Roll.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      await sp.remove(_rollsKey);
      return [];
    }
  }

  Future<void> saveRolls(List<Roll> rolls) async {
    final sp = await _prefs;
    final encoded = jsonEncode(rolls.map((r) => r.toJson()).toList());
    await sp.setString(_rollsKey, encoded);
  }

  Future<int> loadMythsCounter() async {
    final sp = await _prefs;
    return sp.getInt(_mythsKey) ?? 0;
  }

  Future<void> saveMythsCounter(int value) async {
    final sp = await _prefs;
    await sp.setInt(_mythsKey, value);
  }

  Future<void> clear() async {
    final sp = await _prefs;
    await sp.remove(_rollsKey);
    await sp.remove(_mythsKey);
  }
}
