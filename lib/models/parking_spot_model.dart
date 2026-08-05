// lib/models/parking_spot_model.dart
import 'property_model.dart';

class ParkingSpotModel {
  final int id;
  final int propertyId;
  final int? unitId;
  final String label;
  final String type;
  final String status;
  final String block;
  final String qrCodeToken;
  final String createdAt;
  final String updatedAt;
  final PropertyModel? property;
  final dynamic activeAssignment;

  ParkingSpotModel({
    required this.id,
    required this.propertyId,
    this.unitId,
    required this.label,
    required this.type,
    required this.status,
    required this.block,
    required this.qrCodeToken,
    required this.createdAt,
    required this.updatedAt,
    this.property,
    this.activeAssignment,
  });

  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? 0,
      unitId: json['unit_id'] != null ? json['unit_id'] as int? : null,
      label: json['label']?.toString() ?? '',
      type: json['type']?.toString() ?? 'standard',
      status: json['status']?.toString() ?? 'unavailable',
      block: json['block']?.toString() ?? 'A',
      qrCodeToken: json['qr_code_token']?.toString() ?? '',
      createdAt:
          json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt:
          json['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
      property: json['property'] != null
          ? PropertyModel.fromJson(json['property'] as Map<String, dynamic>)
          : null,
      activeAssignment: json['active_assignment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'unit_id': unitId,
      'label': label,
      'type': type,
      'status': status,
      'block': block,
      'qr_code_token': qrCodeToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'property': property?.toJson(),
      'active_assignment': activeAssignment,
    };
  }
}
