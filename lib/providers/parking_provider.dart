// lib/providers/parking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/parking_service.dart';
import '../models/parking_spot_model.dart';
import 'auth_provider.dart';

final parkingServiceProvider = Provider<ParkingService>((ref) => ParkingService());

final parkingSpotsProvider = FutureProvider<List<ParkingSpotModel>>((ref) async {
  final authState = ref.watch(authProvider);
  final token = authState.token;
  if (token == null) {
    throw Exception('Authentication token not found');
  }
  return ref.read(parkingServiceProvider).getParkingSpots(token);
});
