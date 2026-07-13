import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/startup_model.dart';

class StartupRepository {
  final FirebaseFirestore _db;
  StartupRepository(this._db);

  Stream<StartupModel?> watchStartupStatus(String startupId) {
    return _db
        .collection('startups')
        .doc(startupId)
        .snapshots()
        .map(
          (snap) => snap.exists
              ? StartupModel.fromFirestore(snap.id, snap.data()!)
              : null,
        );
  }

  Future<void> createProfile({
    required String startupId,
    required String name,
    required String description,
  }) async {
    await _db.collection('startups').doc(startupId).set({
      'ownerId': startupId,
      'name': name,
      'description': description,
      'status': 'pending',
      'verified': false,
    });
  }
}
