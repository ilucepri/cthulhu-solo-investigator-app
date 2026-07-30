import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';

abstract class CampaignsRepository {
  Future<List<Campaign>> loadAll();
  Future<void> saveCampaign(Campaign campaign);
  Future<void> deleteCampaign(String id);
  Future<void> wipeAll();
}
