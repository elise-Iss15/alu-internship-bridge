class ApplicationModel {
  final String id;
  final String studentId;
  final String studentName;
  final String opportunityId;
  final String opportunityTitle;
  final String startupId;
  final String motivation;
  final String relevantSkill;
  final String availability;
  final String status;

  ApplicationModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.startupId,
    required this.motivation,
    required this.relevantSkill,
    required this.availability,
    required this.status,
  });

  factory ApplicationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ApplicationModel(
      id: id,
      studentId: data['studentId'] as String,
      studentName: data['studentName'] as String,
      opportunityId: data['opportunityId'] as String,
      opportunityTitle: data['opportunityTitle'] as String,
      startupId: data['startupId'] as String,
      motivation: data['motivation'] as String,
      relevantSkill: data['relevantSkill'] as String,
      availability: data['availability'] as String,
      status: data['status'] as String? ?? 'pending',
    );
  }
}
