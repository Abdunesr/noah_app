// lib/models/property_model.dart

class PropertyModel {
  final int id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String country;
  final String postalCode;
  final String phone;
  final String email;
  final String established;
  final String? coverImage;
  final String? logo;
  final String createdAt;
  final String updatedAt;

  PropertyModel({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.established,
    this.coverImage,
    this.logo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      postalCode: json['postal_code'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      established: json['established'] as String,
      coverImage: json['cover_image'] as String?,
      logo: json['logo'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'city': city,
      'country': country,
      'postal_code': postalCode,
      'phone': phone,
      'email': email,
      'established': established,
      'cover_image': coverImage,
      'logo': logo,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
