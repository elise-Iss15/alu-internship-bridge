import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity_model.dart';

class OpportunityRepository {
  final FirebaseFirestore _db;
  OpportunityRepository(this._db);

  Stream<List<OpportunityModel>> watchOpportunities() {
    return _db
        .collection('opportunities')
        .where('status', isEqualTo: 'open')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => OpportunityModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<OpportunityModel>> watchOpportunitiesByStartup(String startupId) {
    return _db
        .collection('opportunities')
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => OpportunityModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> createOpportunity({
    required String startupId,
    required String startupName,
    required String title,
    required String description,
    required String roleType,
    required List<String> skillsNeeded,
  }) async {
    await _db.collection('opportunities').add({
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'roleType': roleType,
      'skillsNeeded': skillsNeeded,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
