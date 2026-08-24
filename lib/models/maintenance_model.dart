// lib/models/maintenance_model.dart
class MaintenanceRequest {
  final int id;
  final int propertyId;
  final int? residentId;
  final int? unitId;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final int? assigneeUserId;
  final DateTime requestedAt;
  final DateTime? resolvedAt;
  final DateTime? closedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Property property;
  final dynamic resident;
  final dynamic unit;
  final dynamic assignee;
  final List<dynamic> comments;

  MaintenanceRequest({
    required this.id,
    required this.propertyId,
    this.residentId,
    this.unitId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    this.assigneeUserId,
    required this.requestedAt,
    this.resolvedAt,
    this.closedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.property,
    this.resident,
    this.unit,
    this.assignee,
    this.comments = const [],
  });

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? 0,
      residentId: json['resident_id'] as int?,
      unitId: json['unit_id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      status: json['status'] as String? ?? '',
      assigneeUserId: json['assignee_user_id'] as int?,
      requestedAt: json['requested_at'] != null 
          ? DateTime.tryParse(json['requested_at']) ?? DateTime.now()
          : DateTime.now(),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'])
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.tryParse(json['closed_at'])
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      property: json['property'] != null
          ? Property.fromJson(json['property'] as Map<String, dynamic>)
          : Property(
              id: 0,
              name: '',
              code: '',
              address: '',
              city: '',
              country: '',
              postalCode: '',
              phone: '',
              email: '',
              established: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      resident: json['resident'],
      unit: json['unit'],
      assignee: json['assignee'],
      comments: json['comments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'unit': unit?.toString() ?? '',
      'property_id': propertyId,
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
  final DateTime createdAt;
  final DateTime updatedAt;

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
      id: json['id'] as int? ?? 0,
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
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

// Paginated response model
class PaginatedResponse<T> {
  final int currentPage;
  final List<T> data;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final List<dynamic> dataList = (json['data'] as List<dynamic>?) ?? [];
    final List<T> typedData = dataList
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponse<T>(
      currentPage: json['current_page'] as int? ?? 1,
      data: typedData,
      firstPageUrl: json['first_page_url'] as String?,
      from: json['from'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
      lastPageUrl: json['last_page_url'] as String?,
      links: (json['links'] as List<dynamic>? ?? [])
          .map((item) => Link.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String? ?? '',
      perPage: json['per_page'] as int? ?? 20,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

class Link {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  Link({this.url, required this.label, this.page, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String? ?? '',
      page: json['page'] as int?,
      active: json['active'] as bool? ?? false,
    );
  }
}

