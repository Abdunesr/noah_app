// lib/providers/property_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/property_service.dart';
import '../models/property_model.dart';
import 'auth_provider.dart';

final propertyServiceProvider = Provider<PropertyService>((ref) => PropertyService());

// Change this to return a list of properties
final propertyProvider = FutureProvider<List<PropertyModel>>((ref) async {
  final authState = ref.watch(authProvider);
  final token = authState.token;
  if (token == null) {
    throw Exception('Authentication token not found');
  }
  return ref.read(propertyServiceProvider).getProperties(token);
});

// Keep this for backward compatibility if needed
final firstPropertyProvider = FutureProvider<PropertyModel>((ref) async {
  final properties = await ref.watch(propertyProvider.future);
  if (properties.isEmpty) {
    throw Exception('No properties found');
  }
  return properties.first;
});