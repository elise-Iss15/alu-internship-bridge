import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/application_repository.dart';
import '../../../data/models/application_model.dart';

final applicationRepositoryProvider = Provider(
  (ref) => ApplicationRepository(FirebaseFirestore.instance),
);

final myApplicationsProvider =
    StreamProvider.family<List<ApplicationModel>, String>((ref, studentId) {
      return ref
          .watch(applicationRepositoryProvider)
          .watchMyApplications(studentId);
    });

final hasAppliedProvider =
    StreamProvider.family<bool, ({String studentId, String opportunityId})>((
      ref,
      params,
    ) {
      return ref
          .watch(applicationRepositoryProvider)
          .hasApplied(params.studentId, params.opportunityId);
    });
