// lib/services/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.greenparknoah.com/api';
  static const String baseUrl2 = 'https://api.greenparknoah.com';

  // Auth Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String logout = '$baseUrl/auth/logout';
  static const String me = '$baseUrl/me';

  // Maintenance Endpoints
  static const String maintenanceRequests = '$baseUrl/maintenance-requests';

  // Parking Endpoints
  static const String parkingSpots = '$baseUrl/parking-spots';
  static String parkingSpotQr(String id) => '$baseUrl/parking-spots/$id/qr';

  // Marketplace Endpoints
  static const String marketplaceListings = '$baseUrl/marketplace-listings';
  static const String propertyBlocks = '$baseUrl/property-blocks';
  static const String propertyFloors = '$baseUrl/property-floors';
  static const String units = '$baseUrl/units';
  static const String mediaUpload = '$baseUrl/media/upload'; // NEW
  static const String properties = '$baseUrl/properties';

  // Calendar Events Endpoint
  static const String calendarEvents = '$baseUrl/calendar-events';

  // Announcements Endpoint
  static const String announcements = '$baseUrl/announcements';
  // Marketplace Endpoints

  static String marketplaceListingViews(int id) =>
      '$baseUrl/marketplace-listings/$id/views';

  // Add to ApiEndpoints class
  // Water Meter Reading Endpoints
  static const String waterMeterReadings = '$baseUrl/water-meter-readings';
  static String waterMeterReadingDetail(int id) =>
      '$baseUrl/water-meter-readings/$id';
}
