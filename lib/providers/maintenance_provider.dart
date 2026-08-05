// lib/providers/maintenance_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maintenance_model.dart';
import '../services/maintenance_service.dart';
import 'auth_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

// State for maintenance requests
class MaintenanceState {
  final bool isLoading;
  final String? errorMessage;
  final List<MaintenanceRequest> requests;
  final PaginatedResponse<MaintenanceRequest>? paginatedResponse;
  final bool hasMoreData;
  final int currentPage;

  MaintenanceState({
    this.isLoading = false,
    this.errorMessage,
    this.requests = const [],
    this.paginatedResponse,
    this.hasMoreData = true,
    this.currentPage = 1,
  });

  MaintenanceState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MaintenanceRequest>? requests,
    PaginatedResponse<MaintenanceRequest>? paginatedResponse,
    bool? hasMoreData,
    int? currentPage,
  }) {
    return MaintenanceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      requests: requests ?? this.requests,
      paginatedResponse: paginatedResponse ?? this.paginatedResponse,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Provider for maintenance service
final maintenanceServiceProvider = Provider<MaintenanceService>((ref) {
  return MaintenanceService();
});

// Notifier for maintenance operations
class MaintenanceNotifier extends StateNotifier<MaintenanceState> {
  final Ref ref;

  MaintenanceNotifier(this.ref) : super(MaintenanceState());

  // Load maintenance requests (initial load or refresh)
  Future<void> loadRequests({bool refresh = false}) async {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token == null || token.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please login to view maintenance requests',
        isLoading: false,
      );
      return;
    }

    // Reset state if refreshing - COMPLETELY reset the list
    if (refresh) {
      state = MaintenanceState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final service = ref.read(maintenanceServiceProvider);
      final page = refresh ? 1 : state.currentPage;

      final response = await service.getMaintenanceRequests(
        token: token,
        page: page,
        perPage: 20,
      );

      // FIX: When refreshing, replace the list; when loading more, append
      final List<MaintenanceRequest> newRequests = response.data
          .cast<MaintenanceRequest>();
      final List<MaintenanceRequest> allRequests;

      if (refresh) {
        // Replace with new data
        allRequests = newRequests;
      } else {
        // Append to existing data, but avoid duplicates
        final existingIds = state.requests.map((r) => r.id).toSet();
        final uniqueNewRequests = newRequests
            .where((r) => !existingIds.contains(r.id))
            .toList();
        allRequests = [...state.requests, ...uniqueNewRequests];
      }

      state = MaintenanceState(
        isLoading: false,
        requests: allRequests,
        paginatedResponse: response,
        hasMoreData: response.nextPageUrl != null,
        currentPage: response.currentPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Load next page for pagination
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMoreData) return;

    // Set loading state before fetching more
    state = state.copyWith(isLoading: true);
    final nextPage = state.currentPage + 1;

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token == null || token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please login to view maintenance requests',
        );
        return;
      }

      final service = ref.read(maintenanceServiceProvider);
      final response = await service.getMaintenanceRequests(
        token: token,
        page: nextPage,
        perPage: 20,
      );

      final List<MaintenanceRequest> newRequests = response.data
          .cast<MaintenanceRequest>();

      // Avoid duplicates
      final existingIds = state.requests.map((r) => r.id).toSet();
      final uniqueNewRequests = newRequests
          .where((r) => !existingIds.contains(r.id))
          .toList();
      final allRequests = [...state.requests, ...uniqueNewRequests];

      state = MaintenanceState(
        isLoading: false,
        requests: allRequests,
        paginatedResponse: response,
        hasMoreData: response.nextPageUrl != null,
        currentPage: response.currentPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Create a new maintenance request
  Future<bool> createRequest({
    required String title,
    required String description,
    required String category,
    required String priority,
    required String unit,
    required int propertyId,
  }) async {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token == null || token.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please login to create a maintenance request',
      );
      return false;
    }

    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final service = ref.read(maintenanceServiceProvider);

      final requestData = {
        'title': title,
        'description': description,
        'category': category,
        'priority': priority,
        'unit': unit,
        'property_id': propertyId,
      };

      final newRequest = await service.createMaintenanceRequest(
        token: token,
        requestData: requestData,
      );

      // Add new request to the list (at the beginning)
      final updatedRequests = [newRequest, ...state.requests];

      state = MaintenanceState(
        isLoading: false,
        requests: updatedRequests,
        hasMoreData: state.hasMoreData,
        currentPage: state.currentPage,
        paginatedResponse: state.paginatedResponse,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Get a single request by ID
  Future<MaintenanceRequest?> getRequestById(int id) async {
    final authState = ref.read(authProvider);
    final token = authState.token;

    if (token == null || token.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please login to view maintenance request details',
      );
      return null;
    }

    try {
      final service = ref.read(maintenanceServiceProvider);
      return await service.getMaintenanceRequestById(token: token, id: id);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Reset state
  void reset() {
    state = MaintenanceState();
  }
}

// Global provider for maintenance
final maintenanceProvider =
    StateNotifierProvider<MaintenanceNotifier, MaintenanceState>((ref) {
      return MaintenanceNotifier(ref);
    });
