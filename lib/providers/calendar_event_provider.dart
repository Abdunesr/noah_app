// lib/providers/calendar_event_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_event_model.dart';
import '../services/calendar_event_service.dart';
import 'auth_provider.dart';

// Provider for CalendarEventService
final calendarEventServiceProvider = Provider<CalendarEventService>((ref) {
  return CalendarEventService();
});

// Provider for fetching calendar events
final calendarEventsProvider = FutureProvider<List<CalendarEvent>>((ref) async {
  final authState = ref.watch(authProvider);
  final token = authState.token;

  if (token == null || token.isEmpty) {
    throw Exception('User not authenticated');
  }

  final service = ref.read(calendarEventServiceProvider);
  return service.getCalendarEvents(token);
});
