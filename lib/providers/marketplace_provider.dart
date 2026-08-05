// lib/providers/marketplace_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/marketplace_model.dart';
import '../services/marketplace_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'auth_provider.dart';

class MarketplaceState {
  final bool isLoading;
  final String? errorMessage;
  final List<MarketplaceListing> listings;
  final MarketplacePaginatedResponse? paginatedResponse;
  final bool hasMoreData;
  final int currentPage;
  final String? selectedListingType;
  final String? selectedPropertyType;
  final String? selectedStatus;
  final String searchQuery;
  final bool isCreating;
  final bool isSuccess;

  MarketplaceState({
    this.isLoading = false,
    this.errorMessage,
    this.listings = const [],
    this.paginatedResponse,
    this.hasMoreData = true,
    this.currentPage = 1,
    this.selectedListingType,
    this.selectedPropertyType,
    this.selectedStatus,
    this.searchQuery = '',
    this.isCreating = false,
    this.isSuccess = false,
  });

  MarketplaceState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MarketplaceListing>? listings,
    MarketplacePaginatedResponse? paginatedResponse,
    bool? hasMoreData,
    int? currentPage,
    String? selectedListingType,
    String? selectedPropertyType,
    String? selectedStatus,
    String? searchQuery,
    bool? isCreating,
    bool? isSuccess,
  }) {
    return MarketplaceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      listings: listings ?? this.listings,
      paginatedResponse: paginatedResponse ?? this.paginatedResponse,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      selectedListingType: selectedListingType ?? this.selectedListingType,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      isCreating: isCreating ?? this.isCreating,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  List<MarketplaceListing> get filteredListings {
    var filtered = listings;

    if (selectedListingType != null && selectedListingType!.isNotEmpty) {
      filtered = filtered
          .where((l) => l.listingType == selectedListingType)
          .toList();
    }

    if (selectedPropertyType != null && selectedPropertyType!.isNotEmpty) {
      filtered = filtered
          .where((l) => l.propertyType == selectedPropertyType)
          .toList();
    }

    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      filtered = filtered
          .where((l) => l.status.toLowerCase() == selectedStatus!.toLowerCase())
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where((l) => l.title.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  List<String> get availableListingTypes {
    return listings.map((l) => l.listingType).toSet().toList();
  }

  List<String> get availablePropertyTypes {
    return listings.map((l) => l.propertyType).toSet().toList();
  }

  List<String> get availableStatuses {
    return listings.map((l) => l.status).toSet().toList();
  }
}

final marketplaceServiceProvider = Provider<MarketplaceService>((ref) {
  return MarketplaceService();
});

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  final Ref ref;

  MarketplaceNotifier(this.ref) : super(MarketplaceState());

  Future<void> loadListings({bool refresh = false}) async {
    if (refresh) {
      state = MarketplaceState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final service = ref.read(marketplaceServiceProvider);
      final page = refresh ? 1 : state.currentPage;
      final token = ref.read(authProvider).token;

      final response = await service.getMarketplaceListings(
        token: token,
        page: page,
        perPage: 20,
      );

      final List<MarketplaceListing> newListings = response.data;
      final List<MarketplaceListing> allListings;

      if (refresh) {
        allListings = newListings;
      } else {
        final existingIds = state.listings.map((l) => l.id).toSet();
        final uniqueNewListings = newListings
            .where((l) => !existingIds.contains(l.id))
            .toList();
        allListings = [...state.listings, ...uniqueNewListings];
      }

      state = MarketplaceState(
        isLoading: false,
        listings: allListings,
        paginatedResponse: response,
        hasMoreData: response.nextPageUrl != null,
        currentPage: response.currentPage,
        selectedListingType: state.selectedListingType,
        selectedPropertyType: state.selectedPropertyType,
        selectedStatus: state.selectedStatus,
        searchQuery: state.searchQuery,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMoreData) return;
    await loadListings(refresh: false);
  }

  void setFilter({String? listingType, String? propertyType, String? status}) {
    state = state.copyWith(
      selectedListingType: listingType,
      selectedPropertyType: propertyType,
      selectedStatus: status,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = state.copyWith(
      selectedListingType: null,
      selectedPropertyType: null,
      selectedStatus: null,
      searchQuery: '',
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = MarketplaceState();
  }
}

final marketplaceProvider =
    StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
      return MarketplaceNotifier(ref);
    });
