// lib/models/announcement_model.dart
class Announcement {
  final int id;
  final int propertyId;
  final String title;
  final String content;
  final String? excerpt;
  final String category;
  final String priority;
  final bool pinned;
  final int viewsCount;
  final int authorUserId;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final Property? property;
  final Author? author;

  Announcement({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.content,
    this.excerpt,
    required this.category,
    required this.priority,
    required this.pinned,
    required this.viewsCount,
    required this.authorUserId,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.property,
    this.author,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int,
      propertyId: json['property_id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      excerpt: json['excerpt'] as String?,
      category: json['category'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      pinned: json['pinned'] as bool? ?? false,
      viewsCount: json['views_count'] as int? ?? 0,
      authorUserId: json['author_user_id'] as int? ?? 0,
      publishedAt: json['published_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      property: json['property'] != null
          ? Property.fromJson(json['property'] as Map<String, dynamic>)
          : null,
      author: json['author'] != null
          ? Author.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'category': category,
      'priority': priority,
      'pinned': pinned,
      'views_count': viewsCount,
      'author_user_id': authorUserId,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'property': property?.toJson(),
      'author': author?.toJson(),
    };
  }
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
  final String? coverImage;
  final String? logo;
  final String createdAt;
  final String updatedAt;

  Property({
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

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: json['postal_code'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      established: json['established'] as String? ?? '',
      coverImage: json['cover_image'] as String?,
      logo: json['logo'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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

class Author {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String status;
  final String lastActiveAt;
  final dynamic emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  Author({
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

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: json['status'] as String? ?? '',
      lastActiveAt: json['last_active_at'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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

