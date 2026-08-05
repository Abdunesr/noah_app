// lib/providers/water_meter_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/water_meter_model.dart';
import '../services/water_meter_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final waterMeterServiceProvider = Provider<WaterMeterService>((ref) {
  return WaterMeterService();
});

class WaterMeterState {
  final bool isLoading;
  final String? errorMessage;
  final List<WaterMeterReading> readings;
  final bool hasMoreData;
  final int currentPage;
  final bool isSubmitting;
  final bool submitSuccess;

  WaterMeterState({
    this.isLoading = false,
    this.errorMessage,
    this.readings = const [],
    this.hasMoreData = true,
    this.currentPage = 1,
    this.isSubmitting = false,
    this.submitSuccess = false,
  });

  WaterMeterState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<WaterMeterReading>? readings,
    bool? hasMoreData,
    int? currentPage,
    bool? isSubmitting,
    bool? submitSuccess,
  }) {
    return WaterMeterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      readings: readings ?? this.readings,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }
}

class WaterMeterNotifier extends StateNotifier<WaterMeterState> {
  final Ref ref;

  WaterMeterNotifier(this.ref) : super(WaterMeterState());

  Future<void> loadReadings({bool refresh = false}) async {
    if (refresh) {
      state = WaterMeterState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final service = ref.read(waterMeterServiceProvider);
      final page = refresh ? 1 : state.currentPage;

      // Pass 'ref' as the first argument
      final readings = await service.getReadings(ref, page: page, perPage: 20);

      final allReadings = refresh ? readings : [...state.readings, ...readings];

      state = WaterMeterState(
        isLoading: false,
        readings: allReadings,
        hasMoreData: readings.length == 20,
        currentPage: page,
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
    await loadReadings(refresh: false);
  }

  Future<bool> createReading(WaterMeterReadingRequest request) async {
    state = state.copyWith(isSubmitting: true, submitSuccess: false);

    try {
      final service = ref.read(waterMeterServiceProvider);
      // Pass 'ref' as the first argument
      final reading = await service.createReading(ref, request);

      state = WaterMeterState(
        isLoading: false,
        readings: [reading, ...state.readings],
        hasMoreData: state.hasMoreData,
        currentPage: state.currentPage,
        isSubmitting: false,
        submitSuccess: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        submitSuccess: false,
      );
      return false;
    }
  }

  Future<bool> verifyReading(int id) async {
    try {
      final service = ref.read(waterMeterServiceProvider);
      // Pass 'ref' as the first argument
      final updatedReading = await service.verifyReading(ref, id);

      final updatedReadings = state.readings.map((reading) {
        if (reading.id == id) {
          return updatedReading;
        }
        return reading;
      }).toList();

      state = state.copyWith(readings: updatedReadings);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> deleteReading(int id) async {
    try {
      final service = ref.read(waterMeterServiceProvider);
      // Pass 'ref' as the first argument
      await service.deleteReading(ref, id);

      final updatedReadings = state.readings
          .where((reading) => reading.id != id)
          .toList();

      state = state.copyWith(readings: updatedReadings);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void resetSubmitState() {
    state = state.copyWith(isSubmitting: false, submitSuccess: false);
  }

  void reset() {
    state = WaterMeterState();
  }
}

final waterMeterProvider =
    StateNotifierProvider<WaterMeterNotifier, WaterMeterState>((ref) {
      return WaterMeterNotifier(ref);
    });
