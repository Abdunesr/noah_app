// lib/models/user_model.dart

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String status;
  final String? emailVerifiedAt;
  final String? lastActiveAt;
  final String createdAt;
  final String updatedAt;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    this.emailVerifiedAt,
    this.lastActiveAt,
    required this.createdAt,
    required this.updatedAt,
    this.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      lastActiveAt: json['last_active_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'last_active_at': lastActiveAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'roles': roles,
    };
  }

  bool get isAdmin => roles.any((r) => r.toLowerCase() == 'admin');

  bool get isWaterReader => roles.any((r) {
    final name = r.toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    return name == 'waterreader';
  });

  bool get isResident => roles.any((r) => r.toLowerCase() == 'resident');
}
