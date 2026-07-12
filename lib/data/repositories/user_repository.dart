import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _db;
  UserRepository(this._db);

  Future<void> toggleBookmark(
    String uid,
    String opportunityId,
    bool isSaved,
  ) async {
    await _db.collection('users').doc(uid).update({
      'savedOpportunities': isSaved
          ? FieldValue.arrayRemove([opportunityId])
          : FieldValue.arrayUnion([opportunityId]),
    });
  }
}
