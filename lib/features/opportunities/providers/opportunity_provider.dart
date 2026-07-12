import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/opportunity_repository.dart';
import '../../../data/models/opportunity_model.dart';

final opportunityRepositoryProvider = Provider(
  (ref) => OpportunityRepository(FirebaseFirestore.instance),
);

final opportunityListProvider = StreamProvider<List<OpportunityModel>>((ref) {
  return ref.watch(opportunityRepositoryProvider).watchOpportunities();
});

final myOpportunitiesProvider =
    StreamProvider.family<List<OpportunityModel>, String>((ref, startupId) {
      return ref
          .watch(opportunityRepositoryProvider)
          .watchOpportunitiesByStartup(startupId);
    });
