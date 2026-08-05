// lib/models/marketplace_model.dart
class MarketplaceListing {
  final int id;
  final int? propertyId;
  final int? blockId;
  final int? floorId;
  final int? unitId;
  final String title;
  final String listingType;
  final String propertyType;
  final String status;
  final bool featured;
  final int bedrooms;
  final int bathrooms;
  final String areaSqm;
  final String price;
  final String? agentName;
  final String? agentPhone;
  final String description;
  final int likesCount;
  final int viewsCount;
  final DateTime? listedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MarketplaceImage> images;
  final List<MarketplaceAmenity> amenities;
  final dynamic property;
  final dynamic block;
  final bool? favorited; // Add
  final dynamic floor;
  final dynamic unit;

  MarketplaceListing({
    required this.id,
    this.propertyId,
    this.blockId,
    this.floorId,
    this.unitId,
    this.favorited,
    required this.title,
    required this.listingType,
    required this.propertyType,
    required this.status,
    required this.featured,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqm,
    required this.price,

    this.agentName,
    this.agentPhone,
    required this.description,
    required this.likesCount,
    required this.viewsCount,
    this.listedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.amenities,
    this.property,
    this.block,
    this.floor,
    this.unit,
  });

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    return MarketplaceListing(
      id: json['id'] ?? 0,
      propertyId: json['property_id'],
      blockId: json['block_id'],
      floorId: json['floor_id'],
      unitId: json['unit_id'],
      favorited: json['favorited'] ?? json['is_favorited'] ?? false,
      title: json['title'] ?? '',
      listingType: json['listing_type'] ?? 'For Sale',
      propertyType: json['property_type'] ?? 'Apartment',
      status: json['status'] ?? 'Available',
      featured: json['featured'] ?? false,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      areaSqm: json['area_sqm']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      agentName: json['agent_name'],
      agentPhone: json['agent_phone'],
      description: json['description'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      listedAt: json['listed_at'] != null
          ? DateTime.parse(json['listed_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: (json['images'] as List? ?? [])
          .map((item) => MarketplaceImage.fromJson(item))
          .toList(),
      amenities: (json['amenities'] as List? ?? [])
          .map((item) => MarketplaceAmenity.fromJson(item))
          .toList(),
      property: json['property'],
      block: json['block'],
      floor: json['floor'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'listing_type': listingType,
      'property_type': propertyType,
      'status': status,
      'price': double.tryParse(price) ?? 0,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area_sqm': double.tryParse(areaSqm) ?? 0,
      'description': description,
      'amenities': amenities.map((a) => a.amenity).toList(),
      'block_id': blockId,
      'floor_id': floorId,
      'unit_id': unitId,
      'images': [],
    };
  }

  String get formattedPrice {
    final priceNum = double.tryParse(price) ?? 0;
    if (priceNum >= 1000000) {
      return '${(priceNum / 1000000).toStringAsFixed(1)}M';
    } else if (priceNum >= 1000) {
      return '${(priceNum / 1000).toStringAsFixed(1)}K';
    }
    return priceNum.toStringAsFixed(0);
  }

  String get fullPrice {
    final priceNum = double.tryParse(price) ?? 0;
    return priceNum.toStringAsFixed(0);
  }

  String get listingTypeIcon {
    switch (listingType.toLowerCase()) {
      case 'for sale':
        return '💰';
      case 'for rent':
        return '🏠';
      default:
        return '🏢';
    }
  }
}

class MarketplaceImage {
  final int id;
  final int listingId;
  final String pathOrUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketplaceImage({
    required this.id,
    required this.listingId,
    required this.pathOrUrl,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketplaceImage.fromJson(Map<String, dynamic> json) {
    return MarketplaceImage(
      id: json['id'] ?? 0,
      listingId: json['listing_id'] ?? 0,
      pathOrUrl: json['path_or_url'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get imageUrl => pathOrUrl;
}

class MarketplaceAmenity {
  final int id;
  final int listingId;
  final String amenity;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketplaceAmenity({
    required this.id,
    required this.listingId,
    required this.amenity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketplaceAmenity.fromJson(Map<String, dynamic> json) {
    return MarketplaceAmenity(
      id: json['id'] ?? 0,
      listingId: json['listing_id'] ?? 0,
      amenity: json['amenity'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class MarketplacePaginatedResponse {
  final int currentPage;
  final List<MarketplaceListing> data;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final List<MarketplaceLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  MarketplacePaginatedResponse({
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

  factory MarketplacePaginatedResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return MarketplacePaginatedResponse(
      currentPage: json['current_page'] ?? 1,
      data: dataList
          .map(
            (item) => MarketplaceListing.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List<dynamic>? ?? [])
          .map((item) => MarketplaceLink.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 20,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class MarketplaceLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  MarketplaceLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory MarketplaceLink.fromJson(Map<String, dynamic> json) {
    return MarketplaceLink(
      url: json['url'],
      label: json['label'] ?? '',
      page: json['page'],
      active: json['active'] ?? false,
    );
  }
}

// ==================== CREATE LISTING MODELS ====================

class PropertyBlock {
  final int id;
  final int propertyId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyBlock({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyBlock.fromJson(Map<String, dynamic> json) {
    return PropertyBlock(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class PropertyFloor {
  final int id;
  final int propertyId;
  final int blockId;
  final int level;
  final String label;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyFloor({
    required this.id,
    required this.propertyId,
    required this.blockId,
    required this.level,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyFloor.fromJson(Map<String, dynamic> json) {
    return PropertyFloor(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      blockId: json['block_id'] ?? 0,
      level: json['level'] ?? 0,
      label: json['label'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String toString() => label;
}

class PropertyUnit {
  final int id;
  final int propertyId;
  final int? blockId;
  final int? floorId;
  final String code;
  final String type;
  final String status;
  final String? areaSqm;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyUnit({
    required this.id,
    required this.propertyId,
    this.blockId,
    this.floorId,
    required this.code,
    required this.type,
    required this.status,
    this.areaSqm,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyUnit.fromJson(Map<String, dynamic> json) {
    return PropertyUnit(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      blockId: json['block_id'],
      floorId: json['floor_id'],
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      areaSqm: json['area_sqm']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String toString() => code;
}

// ==================== CREATE LISTING REQUEST ====================

class CreateListingRequest {
  final String title;
  final String listingType;
  final String propertyType;
  final String status;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double areaSqm;
  final String description;
  final List<String> amenities;
  final int? blockId;
  final int? floorId;
  final int? unitId;
  final List<String> images;

  CreateListingRequest({
    required this.title,
    required this.listingType,
    required this.propertyType,
    required this.status,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqm,
    required this.description,
    required this.amenities,
    this.blockId,
    this.floorId,
    this.unitId,
    this.images = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'listing_type': listingType,
      'property_type': propertyType,
      'status': status,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area_sqm': areaSqm,
      'description': description,
      'amenities': amenities,
      'block_id': blockId,
      'floor_id': floorId,
      'unit_id': unitId,
      'images': images,
    };
  }
}

// ==================== FAVORITE RESPONSE ====================

class FavoriteResponse {
  final bool favorited;
  final int likesCount;

  FavoriteResponse({required this.favorited, required this.likesCount});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      favorited: json['favorited'] ?? false,
      likesCount: json['likes_count'] ?? 0,
    );
  }
}

// ==================== CONTACT REQUEST MODELS ====================

class ContactRequest {
  final String name;
  final String email;
  final String phone;
  final String message;
  final String requestType;
  final DateTime? preferredVisitAt;

  ContactRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    this.requestType = 'schedule',
    this.preferredVisitAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'request_type': requestType,
      if (preferredVisitAt != null)
        'preferred_visit_at': preferredVisitAt!.toIso8601String(),
    };
  }
}

class ContactRequestResponse {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final String requestType;
  final String status;
  final int listingId;
  final DateTime? preferredVisitAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContactRequestResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.requestType,
    required this.status,
    required this.listingId,
    this.preferredVisitAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactRequestResponse.fromJson(Map<String, dynamic> json) {
    return ContactRequestResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      message: json['message'] ?? '',
      requestType: json['request_type'] ?? 'schedule',
      status: json['status'] ?? 'Pending',
      listingId: json['listing_id'] ?? 0,
      preferredVisitAt: json['preferred_visit_at'] != null
          ? DateTime.parse(json['preferred_visit_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
