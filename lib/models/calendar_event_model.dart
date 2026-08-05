// lib/models/calendar_event_model.dart
import 'package:equatable/equatable.dart';

class CalendarEvent extends Equatable {
  final int id;
  final int propertyId;
  final String title;
  final String date;
  final String time;
  final String category;
  final String description;
  final int createdByUserId;
  final String createdAt;
  final String updatedAt;
  final Property? property;
  final CreatedBy? createdBy;

  const CalendarEvent({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.date,
    required this.time,
    required this.category,
    required this.description,
    required this.createdByUserId,
    required this.createdAt,
    required this.updatedAt,
    this.property,
    this.createdBy,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as int,
      propertyId: json['property_id'] as int,
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      createdByUserId: json['created_by_user_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      property: json['property'] != null
          ? Property.fromJson(json['property'] as Map<String, dynamic>)
          : null,
      createdBy: json['created_by'] != null
          ? CreatedBy.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'title': title,
      'date': date,
      'time': time,
      'category': category,
      'description': description,
      'created_by_user_id': createdByUserId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'property': property?.toJson(),
      'created_by': createdBy?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    propertyId,
    title,
    date,
    time,
    category,
    description,
    createdByUserId,
    createdAt,
    updatedAt,
    property,
    createdBy,
  ];
}

class Property {
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
  final String coverImage;
  final String logo;
  final String createdAt;
  final String updatedAt;

  const Property({
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
    required this.coverImage,
    required this.logo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
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
      coverImage: json['cover_image'] as String,
      logo: json['logo'] as String,
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

class CreatedBy {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String status;
  final String lastActiveAt;
  final dynamic emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  const CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.lastActiveAt,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      lastActiveAt: json['last_active_at'] as String,
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'last_active_at': lastActiveAt,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
