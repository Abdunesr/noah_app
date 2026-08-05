// lib/models/water_meter_model.dart
import 'dart:convert';

class WaterMeterReading {
  final int id;
  final int propertyId;
  final int? blockId;
  final int? floorId;
  final int unitId;
  final String month;
  final String previousReading;
  final String currentReading;
  final String consumption;
  final DateTime readingDate;
  final String? readerEmployee;
  final String? notes;
  final String status;
  final int? submittedByUserId;
  final int? verifiedByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Unit? unit;
  final Block? block;
  final Floor? floor;
  final User? submittedBy;
  final User? verifiedBy;

  WaterMeterReading({
    required this.id,
    required this.propertyId,
    this.blockId,
    this.floorId,
    required this.unitId,
    required this.month,
    required this.previousReading,
    required this.currentReading,
    required this.consumption,
    required this.readingDate,
    this.readerEmployee,
    this.notes,
    required this.status,
    this.submittedByUserId,
    this.verifiedByUserId,
    required this.createdAt,
    required this.updatedAt,
    this.unit,
    this.block,
    this.floor,
    this.submittedBy,
    this.verifiedBy,
  });

  factory WaterMeterReading.fromJson(Map<String, dynamic> json) {
    return WaterMeterReading(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      blockId: json['block_id'],
      floorId: json['floor_id'],
      unitId: json['unit_id'] ?? 0,
      month: json['month'] ?? '',
      previousReading: json['previous_reading']?.toString() ?? '0',
      currentReading: json['current_reading']?.toString() ?? '0',
      consumption: json['consumption']?.toString() ?? '0',
      readingDate: json['reading_date'] != null
          ? DateTime.parse(json['reading_date'])
          : DateTime.now(),
      readerEmployee: json['reader_employee'],
      notes: json['notes'],
      status: json['status'] ?? 'draft',
      submittedByUserId: json['submitted_by_user_id'],
      verifiedByUserId: json['verified_by_user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      block: json['block'] != null ? Block.fromJson(json['block']) : null,
      floor: json['floor'] != null ? Floor.fromJson(json['floor']) : null,
      submittedBy: json['submitted_by'] != null
          ? User.fromJson(json['submitted_by'])
          : null,
      verifiedBy: json['verified_by'] != null
          ? User.fromJson(json['verified_by'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'block_id': blockId,
      'floor_id': floorId,
      'unit_id': unitId,
      'month': month,
      'previous_reading': previousReading,
      'current_reading': currentReading,
      'consumption': consumption,
      'reading_date': readingDate.toIso8601String(),
      'reader_employee': readerEmployee,
      'notes': notes,
      'status': status,
      'submitted_by_user_id': submittedByUserId,
      'verified_by_user_id': verifiedByUserId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Unit {
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

  Unit({
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

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      blockId: json['block_id'],
      floorId: json['floor_id'],
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      areaSqm: json['area_sqm']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class Block {
  final int id;
  final int propertyId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Block({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class Floor {
  final int id;
  final int propertyId;
  final int? blockId;
  final int level;
  final String label;
  final DateTime createdAt;
  final DateTime updatedAt;

  Floor({
    required this.id,
    required this.propertyId,
    this.blockId,
    required this.level,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      blockId: json['block_id'],
      level: json['level'] ?? 0,
      label: json['label'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String status;
  final DateTime? lastActiveAt;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    this.lastActiveAt,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      status: json['status'] ?? 'Active',
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'])
          : null,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

// Request model for creating a reading
class WaterMeterReadingRequest {
  final int propertyId;
  final int unitId;
  final String month;
  final double previousReading;
  final double currentReading;
  final String readingDate;
  final String? readerEmployee;
  final String? notes;

  WaterMeterReadingRequest({
    required this.propertyId,
    required this.unitId,
    required this.month,
    required this.previousReading,
    required this.currentReading,
    required this.readingDate,
    this.readerEmployee,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'unit_id': unitId,
      'month': month,
      'previous_reading': previousReading % 1 == 0 ? previousReading.toInt() : previousReading,
      'current_reading': currentReading % 1 == 0 ? currentReading.toInt() : currentReading,
      'reading_date': readingDate,
      'reader_employee': readerEmployee,
      'notes': notes,
    };
  }
}