enum StartupStatus { none, pending, verified, rejected }

class StartupModel {
  final String id;
  final String name;
  final String description;
  final StartupStatus status;
  final String? rejectionReason;

  StartupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.rejectionReason,
  });

  factory StartupModel.fromFirestore(String id, Map<String, dynamic> data) {
    return StartupModel(
      id: id,
      name: data['name'] as String,
      description: data['description'] as String,
      status: StartupStatus.values.byName(
        data['status'] as String? ?? 'pending',
      ),
      rejectionReason: data['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'status': status.name,
      'verified': status == StartupStatus.verified,
    };
  }
}
