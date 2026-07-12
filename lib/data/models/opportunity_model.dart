import 'package:cloud_firestore/cloud_firestore.dart';

class OpportunityModel {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final String roleType;
  final List<String> skillsNeeded;
  final String status;
  final DateTime? createdAt;

  OpportunityModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.roleType,
    required this.skillsNeeded,
    required this.status,
    this.createdAt,
  });

  factory OpportunityModel.fromFirestore(String id, Map<String, dynamic> data) {
    return OpportunityModel(
      id: id,
      startupId: data['startupId'] as String,
      startupName: data['startupName'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      roleType: data['roleType'] as String,
      skillsNeeded: List<String>.from(data['skillsNeeded'] ?? []),
      status: data['status'] as String? ?? 'open',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
