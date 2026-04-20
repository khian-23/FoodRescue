class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.userType,
  });

  final String uid;
  final String name;
  final String email;
  final String role;
  final String userType;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'user',
      userType: map['userType'] as String? ?? 'donor',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'userType': userType,
    };
  }
}
