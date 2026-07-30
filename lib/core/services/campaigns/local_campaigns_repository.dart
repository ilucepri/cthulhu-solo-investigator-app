import 'dart:convert';

import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/campaigns_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCampaignsRepository implements CampaignsRepository {
  static const _campaignsKey = 'campaigns.v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<Campaign>> _readAll(SharedPreferences sp) async {
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

  Future<void> _writeAll(SharedPreferences sp, List<Campaign> all) async {
    final encoded = jsonEncode(all.map((c) => c.toJson()).toList());
    await sp.setString(_campaignsKey, encoded);
  }

  @override
  Future<List<Campaign>> loadAll() async => _readAll(await _prefs);

  @override
  Future<void> saveCampaign(Campaign campaign) async {
    final sp = await _prefs;
    final all = await _readAll(sp);
    final idx = all.indexWhere((c) => c.id == campaign.id);
    if (idx == -1) {
      all.add(campaign);
    } else {
      all[idx] = campaign;
    }
    await _writeAll(sp, all);
  }

  @override
  Future<void> deleteCampaign(String id) async {
    final sp = await _prefs;
    final all = await _readAll(sp);
    all.removeWhere((c) => c.id == id);
    await _writeAll(sp, all);
  }

  @override
  Future<void> wipeAll() async {
    final sp = await _prefs;
    await sp.remove(_campaignsKey);
  }
}
