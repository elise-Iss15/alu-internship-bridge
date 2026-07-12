enum UserRole { student, startup }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final List<String> savedOpportunities;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.savedOpportunities = const [],
  });

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] as String,
      name: data['name'] as String,
      role: UserRole.values.byName(data['role'] as String),
      savedOpportunities: List<String>.from(data['savedOpportunities'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role.name,
      'savedOpportunities': <String>[],
    };
  }
}
