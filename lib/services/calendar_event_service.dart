// lib/services/calendar_event_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/calendar_event_model.dart';
import 'api_endpoints.dart';

class CalendarEventService {
  final http.Client client;

  CalendarEventService({http.Client? client})
    : client = client ?? http.Client();

  Future<List<CalendarEvent>> getCalendarEvents(String token) async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.calendarEvents),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] as List<dynamic>;

        return data
            .map((item) => CalendarEvent.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load calendar events: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load calendar events: $e');
    }
  }
}
