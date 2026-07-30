import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/services/campaigns/campaigns_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudCampaignsRepository implements CampaignsRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CloudCampaignsRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) {
      throw StateError('CloudCampaignsRepository requiere sesión iniciada');
    }
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> get _campaigns =>
      _firestore.collection('users').doc(_uid).collection('campaigns');

  @override
  Future<List<Campaign>> loadAll() async {
    final snap = await _campaigns.get();
    return snap.docs.map((d) => Campaign.fromJson(d.data())).toList();
  }

  @override
  Future<void> saveCampaign(Campaign campaign) async {
    await _campaigns.doc(campaign.id).set(campaign.toJson());
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await _campaigns.doc(id).delete();
  }

  @override
  Future<void> wipeAll() async {
    final snap = await _campaigns.get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}
