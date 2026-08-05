// lib/screens/parking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/shimmer_parking_card.dart';
import '../widgets/shimmer_stats_card.dart';
import 'qr_scanner_screen.dart';
import '../providers/parking_provider.dart';
import '../models/parking_spot_model.dart';

class ParkingScreen extends ConsumerStatefulWidget {
  const ParkingScreen({super.key});

  @override
  ConsumerState<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends ConsumerState<ParkingScreen> {
  final int _currentIndex = 2; // Parking tab (index 2) is active

  @override
  Widget build(BuildContext context) {
    // Check screen width for web/desktop mockup responsive wrapping
    final double screenWidth = MediaQuery.of(context).size.width;
    Widget screenContent = _buildScreenContent(context);

    if (screenWidth > 500) {
      return Scaffold(
        backgroundColor: const Color(
          0xFF1E2022,
        ), // Sleek slate outer background
        body: Center(
          child: Container(
            width: 390,
            height: 844,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFF8E9196), // Outer phone bezel
                width: 10,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: screenContent,
            ),
          ),
        ),
      );
    }

    return screenContent;
  }

  Widget _buildScreenContent(BuildContext context) {
    final spotsAsyncValue = ref.watch(parkingSpotsProvider);

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: spotsAsyncValue.when(
                data: (spots) => RefreshIndicator(
                  onRefresh: () => ref.refresh(parkingSpotsProvider.future),
                  color: AppColors.primaryGreen,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _buildAvailabilityCard(spots),
                        const SizedBox(height: 18),
                        _buildSearchAndFilterRow(),
                        const SizedBox(height: 24),
                        _buildLocationsHeader(),
                        const SizedBox(height: 14),
                        _buildLocationsList(spots),
                        const SizedBox(height: 20),
                        _buildStatsRow(),
                        const SizedBox(
                          height: 80,
                        ), // Extra bottom padding for floating button
                      ],
                    ),
                  ),
                ),
                loading: () => _buildShimmerContent(),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ref.refresh(parkingSpotsProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildScanQRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/bills');
          } else if (index == 2) {
            // Already on Parking
          } else if (index == 3) {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildShimmerContent() {
    return ShimmerLoading(
      isLoading: true,
      shimmerChild: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Availability Card Shimmer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF85B842),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Container(
                        height: 34,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 18,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 13,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Search Bar Shimmer
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Locations Header Shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 18,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Parking Cards Shimmer - Fixed list type
            ...List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: ShimmerParkingCard(),
              ),
            ),
            const SizedBox(height: 20),
            // Stats Row Shimmer
            Row(
              children: [
                const Expanded(child: ShimmerStatsCard()),
                const SizedBox(width: 14),
                const Expanded(child: ShimmerStatsCard()),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      child: Container(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF0D0F0C),
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Estate Flow',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen, // Green page title
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              // Help action
            },
            icon: const Icon(
              Icons.help_outline,
              color: Color(0xFF0D0F0C),
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard(List<ParkingSpotModel> spots) {
    final availableCount = spots
        .where((spot) => spot.status.toLowerCase() == 'available')
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF85B842), // Vibrant lime green
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background "P" watermark shape
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF85B842).withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Foreground Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL AVAILABILITY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3D00), // Dark green
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$availableCount',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F1E01), // Dark green-black
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'spaces',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF0F1E01),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(
                width: 220,
                child: Text(
                  'Real-time parking availability across all building levels.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1B3D00), // Dark green text
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        // Search locations input
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8), // Light gray-blue, no border!
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search locations...',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Filter button
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8), // Matches search bar
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              // Filter Action
            },
            icon: const Icon(Icons.tune, color: Color(0xFF0D0F0C), size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Parking Locations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D0F0C),
          ),
        ),
        GestureDetector(
          onTap: () {
            // View Map action
          },
          child: const Text(
            'View Map',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationsList(List<ParkingSpotModel> spots) {
    if (spots.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'No parking spots found.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: spots.map((spot) {
        final isAvailable = spot.status.toLowerCase() == 'available';

        return InkWell(
          onTap: () => _showSpotDetailsBottomSheet(spot),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_car_outlined,
                    color: isAvailable
                        ? AppColors.primaryGreen
                        : const Color(0xFFD32F2F),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Location Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${spot.block} ${spot.label}${spot.id}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: isAvailable
                                  ? AppColors.primaryGreen
                                  : const Color(0xFFD32F2F),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            spot.status,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '(${spot.type})',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chevron Arrow
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        // Avg. Stay Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.history,
                  color: Color(0xFF1E3A8A), // Dark blue
                  size: 24,
                ),
                SizedBox(height: 12),
                Text(
                  '2.4h',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Avg. Stay',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Dues Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: AppColors.primaryGreen, // Green
                  size: 24,
                ),
                SizedBox(height: 12),
                Text(
                  '\$12.50',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Dues',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanQRButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _onScanClicked,
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 18),
        label: const Text(
          'Scan QR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _onScanClicked() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (result != null && mounted) {
      final spotsAsyncValue = ref.read(parkingSpotsProvider);
      String validationMessage =
          'Your parking location has been successfully validated. Resident access is confirmed.';
      String spotDetails = '';

      spotsAsyncValue.whenData((spots) {
        try {
          final matchedSpot = spots.firstWhere(
            (spot) => spot.qrCodeToken == result.toString(),
          );
          spotDetails =
              '\nSpot: ${matchedSpot.block} ${matchedSpot.label}${matchedSpot.id}';
          validationMessage =
              'Parking authorization matches and is verified for: ${matchedSpot.property?.name ?? "Green Park Properties"}.\nResident access confirmed.';
        } catch (e) {
          validationMessage =
              'Scanned code does not match any registered parking spot in your profile.';
        }
      });

      _showScanResultDialog(result.toString(), validationMessage, spotDetails);
    }
  }

  void _showScanResultDialog(String code, String message, String spotDetails) {
    showDialog(
      context: context,
      builder: (context) {
        final isValid = !message.contains('does not match');
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isValid
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isValid ? Icons.check_circle_outline : Icons.error_outline,
                    color: isValid
                        ? AppColors.primaryGreen
                        : const Color(0xFFD32F2F),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isValid ? 'Scan Successful' : 'Validation Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isValid
                        ? AppColors.textPrimary
                        : const Color(0xFFD32F2F),
                  ),
                ),
                const SizedBox(height: 12),
                // Show QR code instead of raw token
                if (isValid) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: QrImageView(
                      data: code,
                      version: QrVersions.auto,
                      size: 160.0, // Made bigger
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF0D0F0C),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF0D0F0C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Parking Pass #${code.substring(0, 6)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                // Only show spot details without the raw token
                if (spotDetails.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    spotDetails,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid
                          ? AppColors.primaryGreen
                          : const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSpotDetailsBottomSheet(ParkingSpotModel spot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isAvailable = spot.status.toLowerCase() == 'available';

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // QR CODE AT THE TOP - LARGE AND CENTERED
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderDefault,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: spot.qrCodeToken,
                        version: QrVersions.auto,
                        size:
                            220.0, // BIG FUCKING QR CODE - LARGE ENOUGH TO SCAN
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF0D0F0C),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF0D0F0C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${spot.block} ${spot.label}${spot.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFEBEC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        spot.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isAvailable
                              ? AppColors.primaryGreen
                              : const Color(0xFFD32F2F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Parking Pass #${spot.qrCodeToken.substring(0, 8)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(color: AppColors.borderDefault, height: 1),
              const SizedBox(height: 16),

              // DETAILS BELOW
              _buildDetailRow('Type', spot.type),
              const SizedBox(height: 10),
              _buildDetailRow('Block', spot.block),
              const SizedBox(height: 10),
              _buildDetailRow(
                'Property',
                spot.property?.name ?? 'Green Park Properties',
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
