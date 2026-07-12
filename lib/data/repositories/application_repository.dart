import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final FirebaseFirestore _db;
  ApplicationRepository(this._db);

  Future<void> submitApplication({
    required String studentId,
    required String studentName,
    required String opportunityId,
    required String opportunityTitle,
    required String startupId,
    required String motivation,
    required String relevantSkill,
    required String availability,
  }) async {
    await _db.collection('applications').add({
      'studentId': studentId,
      'studentName': studentName,
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'startupId': startupId,
      'motivation': motivation,
      'relevantSkill': relevantSkill,
      'availability': availability,
      'status': 'pending',
    });
  }

  Stream<List<ApplicationModel>> watchMyApplications(String studentId) {
    return _db
        .collection('applications')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ApplicationModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<bool> hasApplied(String studentId, String opportunityId) {
    return _db
        .collection('applications')
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty);
  }
}
