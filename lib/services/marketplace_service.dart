// lib/services/marketplace_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/marketplace_model.dart';
import 'api_endpoints.dart';

class MarketplaceService {
  final http.Client _client;

  MarketplaceService({http.Client? client}) : _client = client ?? http.Client();

  Future<MarketplacePaginatedResponse> getMarketplaceListings({
    String? token,
    int page = 1,
    int perPage = 20,
    String? listingType,
    String? propertyType,
    String? status,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (listingType != null &&
          listingType.isNotEmpty &&
          listingType != 'All') {
        queryParams['listing_type'] = listingType;
      }
      if (propertyType != null &&
          propertyType.isNotEmpty &&
          propertyType != 'All') {
        queryParams['property_type'] = propertyType;
      }
      if (status != null && status.isNotEmpty && status != 'All') {
        queryParams['status'] = status;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse(ApiEndpoints.marketplaceListings).replace(
        queryParameters: queryParams.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final Map<String, dynamic> responseData =
            jsonResponse['data'] as Map<String, dynamic>;
        return MarketplacePaginatedResponse.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to load marketplace listings',
        );
      }
    } catch (e) {
      throw Exception('Error fetching marketplace listings: $e');
    }
  }

  Future<MarketplaceListing> getMarketplaceListingById(
    int id, {
    String? token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiEndpoints.marketplaceListings}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MarketplaceListing.fromJson(
          jsonResponse['data'] ?? jsonResponse,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Listing not found');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to load listing details',
        );
      }
    } catch (e) {
      throw Exception('Error fetching listing details: $e');
    }
  }

  // ==================== PROPERTY LOADING ENDPOINTS ====================

  Future<List<PropertyBlock>> getPropertyBlocks(String token) async {
    try {
      final response = await _client.get(
        Uri.parse(ApiEndpoints.propertyBlocks),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataList = jsonResponse['data'] as List<dynamic>;
        return dataList
            .map((item) => PropertyBlock.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load blocks');
      }
    } catch (e) {
      throw Exception('Error fetching blocks: $e');
    }
  }

  Future<List<PropertyFloor>> getPropertyFloors(
    String token,
    int blockId,
  ) async {
    try {
      final uri = Uri.parse(
        ApiEndpoints.propertyFloors,
      ).replace(queryParameters: {'block_id': blockId.toString()});

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataList = jsonResponse['data'] as List<dynamic>;
        return dataList
            .map((item) => PropertyFloor.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load floors');
      }
    } catch (e) {
      throw Exception('Error fetching floors: $e');
    }
  }

  Future<List<PropertyUnit>> getPropertyUnits(
    String token, {
    int? blockId,
    int? floorId,
  }) async {
    try {
      final Map<String, String> queryParams = {};
      if (blockId != null) {
        queryParams['block_id'] = blockId.toString();
      }
      if (floorId != null) {
        queryParams['floor_id'] = floorId.toString();
      }

      final uri = Uri.parse(
        ApiEndpoints.units,
      ).replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataList = jsonResponse['data'] as List<dynamic>;
        return dataList
            .map((item) => PropertyUnit.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load units');
      }
    } catch (e) {
      throw Exception('Error fetching units: $e');
    }
  }

  // ==================== IMAGE UPLOAD - USING /media/upload ====================

  Future<List<String>> uploadImages({
    required String token,
    required List<File> imageFiles,
  }) async {
    final List<String> uploadedUrls = [];

    for (final file in imageFiles) {
      try {
        final uri = Uri.parse(ApiEndpoints.mediaUpload);
        final request = http.MultipartRequest('POST', uri)
          ..headers['Accept'] = 'application/json'
          ..headers['Authorization'] = 'Bearer $token';

        final fileBytes = await file.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: file.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);

        print('📤 Uploading image: ${file.path.split('/').last}');

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print('📥 Upload response status: ${response.statusCode}');
        print('📥 Upload response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          // Extract the path from the response
          String imagePath = '';
          if (jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];
            if (data is Map<String, dynamic>) {
              imagePath = data['path'] ?? '';
            }
          }

          if (imagePath.isNotEmpty) {
            // Construct the full URL
            final fullUrl = '${ApiEndpoints.baseUrl2}/storage/$imagePath';
            uploadedUrls.add(fullUrl);
            print('✅ Image uploaded successfully: $fullUrl');
          } else {
            print('⚠️ Image uploaded but path not found in response');
            throw Exception('Could not extract image path from response');
          }
        } else {
          try {
            final Map<String, dynamic> errorData = json.decode(response.body);
            throw Exception(errorData['message'] ?? 'Failed to upload image');
          } catch (e) {
            throw Exception('Failed to upload image: ${response.statusCode}');
          }
        }
      } catch (e) {
        print('❌ Error uploading image: $e');
        throw Exception('Error uploading image: $e');
      }
    }

    return uploadedUrls;
  }
  // lib/services/marketplace_service.dart - Add these new methods

  // ==================== FAVORITE METHODS ====================

  Future<FavoriteResponse> toggleFavorite({
    required String token,
    required int listingId,
    required bool favorited,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiEndpoints.marketplaceListings}/$listingId/favorite'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'favorited': favorited}),
      );

      print('📥 Favorite response status: ${response.statusCode}');
      print('📥 Favorite response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return FavoriteResponse.fromJson(jsonResponse['data'] ?? jsonResponse);
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to toggle favorite');
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  // ==================== CONTACT REQUEST METHODS ====================

  Future<ContactRequestResponse> submitContactRequest({
    required String token,
    required int listingId,
    required ContactRequest request,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '${ApiEndpoints.marketplaceListings}/$listingId/contact-requests',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      print('📥 Contact request response status: ${response.statusCode}');
      print('📥 Contact request response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ContactRequestResponse.fromJson(
          jsonResponse['data'] ?? jsonResponse,
        );
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to submit contact request',
        );
      }
    } catch (e) {
      throw Exception('Error submitting contact request: $e');
    }
  }
  // ==================== CREATE LISTING ====================

  Future<MarketplaceListing> createListing({
    required String token,
    required CreateListingRequest request,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiEndpoints.marketplaceListings),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      print('📥 Create listing response status: ${response.statusCode}');
      print('📥 Create listing response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MarketplaceListing.fromJson(
          jsonResponse['data'] ?? jsonResponse,
        );
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to create listing';

        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final errorMessages = errors.entries
              .map((entry) {
                return '${entry.key}: ${entry.value.join(', ')}';
              })
              .join('\n');
          throw Exception('$errorMessage\n$errorMessages');
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error creating listing: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
