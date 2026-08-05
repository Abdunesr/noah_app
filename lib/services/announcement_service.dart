// lib/services/announcement_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement_model.dart';
import 'api_endpoints.dart';

class AnnouncementService {
  final http.Client client;

  AnnouncementService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Announcement>> getAnnouncements(String token) async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.announcements),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Map<String, dynamic> data =
            jsonData['data'] as Map<String, dynamic>;
        final List<dynamic> announcementsList = data['data'] as List<dynamic>;

        return announcementsList
            .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load announcements: $e');
    }
  }
}
