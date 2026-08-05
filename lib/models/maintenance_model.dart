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
      id: json['id'],
      propertyId: json['property_id'],
      residentId: json['resident_id'],
      unitId: json['unit_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      priority: json['priority'],
      status: json['status'],
      assigneeUserId: json['assignee_user_id'],
      requestedAt: DateTime.parse(json['requested_at']),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'])
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      property: Property.fromJson(json['property']),
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
  final String coverImage;
  final String logo;
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
    required this.coverImage,
    required this.logo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postal_code'],
      phone: json['phone'],
      email: json['email'],
      established: json['established'],
      coverImage: json['cover_image'],
      logo: json['logo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// Paginated response model
// In maintenance_model.dart - Updated PaginatedResponse class
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
    // FIX: Handle the data list properly
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final List<T> typedData = dataList
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    // Create a copy with typed data
    final Map<String, dynamic> modifiedJson = Map.from(json);
    modifiedJson['data'] = typedData;

    return PaginatedResponse<T>(
      currentPage: modifiedJson['current_page'] as int,
      data: typedData,
      firstPageUrl: modifiedJson['first_page_url'] as String?,
      from: modifiedJson['from'] as int? ?? 0,
      lastPage: modifiedJson['last_page'] as int,
      lastPageUrl: modifiedJson['last_page_url'] as String?,
      links: (modifiedJson['links'] as List<dynamic>)
          .map((item) => Link.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextPageUrl: modifiedJson['next_page_url'] as String?,
      path: modifiedJson['path'] as String,
      perPage: modifiedJson['per_page'] as int,
      prevPageUrl: modifiedJson['prev_page_url'] as String?,
      to: modifiedJson['to'] as int? ?? 0,
      total: modifiedJson['total'] as int,
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
      url: json['url'],
      label: json['label'],
      page: json['page'],
      active: json['active'],
    );
  }
}
