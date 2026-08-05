// lib/providers/announcement_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement_model.dart';
import '../services/announcement_service.dart';
import 'auth_provider.dart';

// Provider for AnnouncementService
final announcementServiceProvider = Provider<AnnouncementService>((ref) {
  return AnnouncementService();
});

// Provider for fetching announcements
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final authState = ref.watch(authProvider);
  final token = authState.token;

  if (token == null || token.isEmpty) {
    throw Exception('User not authenticated');
  }

  final service = ref.read(announcementServiceProvider);
  return service.getAnnouncements(token);
});
