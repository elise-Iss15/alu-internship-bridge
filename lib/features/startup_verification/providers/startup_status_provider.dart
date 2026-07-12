import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/startup_repository.dart';
import '../../../data/models/startup_model.dart';

final startupRepositoryProvider = Provider(
  (ref) => StartupRepository(FirebaseFirestore.instance),
);

final startupStatusProvider = StreamProvider.family<StartupModel?, String>((
  ref,
  startupId,
) {
  return ref.watch(startupRepositoryProvider).watchStartupStatus(startupId);
});
