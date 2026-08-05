// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/calendar_event_provider.dart';
import '../utils/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/calendar_event_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Check screen width for web/desktop mockup responsive wrapping
    final double screenWidth = MediaQuery.of(context).size.width;

    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'Alex';

    Widget screenContent = _buildScreenContent(context, userName);

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

  Widget _buildScreenContent(BuildContext context, String userName) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildDashboardRow(userName),
                    const SizedBox(height: 20),
                    _buildNextInspectionBanner(),
                    const SizedBox(height: 20),
                    _buildQuickActionsGrid(),
                    const SizedBox(height: 20),
                    _buildMarketplaceCard(),
                    const SizedBox(height: 14),
                    _buildAnnouncementsCard(),
                    const SizedBox(height: 14),
                    _buildCalendarCard(),
                    const SizedBox(height: 20),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/bills');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/parking');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Image
          Image.asset(
            'assets/logo.png',
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.apartment,
                  size: 20,
                  color: Colors.white,
                ),
              );
            },
          ),
          // Action Buttons
          Row(
            children: [
              // Megaphone Icon (Green)
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/announcements');
                },
                icon: const Icon(
                  Icons.campaign_outlined,
                  color: AppColors.primaryGreen,
                  size: 26,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 18),
              // Notification Bell Icon (Green)
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.primaryGreen,
                  size: 26,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardRow(String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Left Column: Welcome
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DASHBOARD',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back, $userName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        // Right Column: Unpaid Bill Amount
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Unpaid Bill Amount',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFCDD2), width: 0.5),
              ),
              child: const Text(
                '\$1,250.00',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextInspectionBanner() {
    // Watch the calendar events provider
    final calendarEventsAsync = ref.watch(calendarEventsProvider);

    return calendarEventsAsync.when(
      data: (events) {
        // Find the next upcoming event (or pinned event)
        CalendarEvent? nextEvent;

        // First try to find an event with "inspection" in the title
        try {
          nextEvent = events.firstWhere(
            (event) => event.title.toLowerCase().contains('inspection'),
            orElse: () => events.first, // Fallback to first event
          );
        } catch (e) {
          // If no events exist, use fallback
          nextEvent = null;
        }

        if (nextEvent != null) {
          // Format the date
          String formattedDate = _formatDate(nextEvent.date);
          return _buildBannerContent(formattedDate);
        } else {
          // Fallback if no events
          return _buildBannerContent('Oct 24');
        }
      },
      loading: () => _buildBannerContent('Loading...'),
      error: (error, stack) =>
          _buildBannerContent('Oct 24'), // Fallback on error
    );
  }

  String _formatDate(String dateStr) {
    try {
      // Extract only the date part (YYYY-MM-DD) from the full date string
      String cleanDateStr = dateStr;

      // If the string contains 'T', extract everything before it
      if (dateStr.contains('T')) {
        cleanDateStr = dateStr.split('T')[0];
      }

      // If the string contains space, extract the first part
      if (cleanDateStr.contains(' ')) {
        cleanDateStr = cleanDateStr.split(' ')[0];
      }

      // Parse the date string (format: YYYY-MM-DD)
      final dateParts = cleanDateStr.split('-');
      if (dateParts.length == 3) {
        final year = dateParts[0];
        final month = dateParts[1];
        final day = dateParts[2];

        // Month mapping
        const monthNames = {
          '01': 'Jan',
          '02': 'Feb',
          '03': 'Mar',
          '04': 'Apr',
          '05': 'May',
          '06': 'Jun',
          '07': 'Jul',
          '08': 'Aug',
          '09': 'Sep',
          '10': 'Oct',
          '11': 'Nov',
          '12': 'Dec',
        };

        final monthName = monthNames[month] ?? month;
        return '$monthName $day';
      }
      return cleanDateStr;
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildBannerContent(String dateText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF85B842),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Info circle icon
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color(0xFF2A4505),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF85B842),
              size: 16,
            ),
          ),
          const SizedBox(width: 14),
          // Banner text
          Expanded(
            child: Text(
              'Next inspection scheduled for $dateText',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F1E01),
              ),
            ),
          ),
          // Right arrow icon
          const Icon(Icons.chevron_right, color: Color(0xFF0F1E01), size: 22),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.15,
      children: [
        _buildQuickActionCard(
          title: 'Bills & Invoices',
          subtitle: 'View history',
          icon: Icons.credit_card_outlined,
          iconColor: const Color(0xFF3E6A0D),
          circleBgColor: const Color(0xFFE8F5E9),
          route: '/bills',
        ),
        _buildQuickActionCard(
          title: 'Water',
          subtitle: 'Usage reports',
          icon: Icons.opacity,
          iconColor: const Color(0xFF1E88E5),
          circleBgColor: const Color(0xFFE3F2FD),
          route: '/water',
        ),
        _buildQuickActionCard(
          title: 'Parking',
          subtitle: 'Spot B-12',
          icon: Icons.directions_car_outlined,
          iconColor: const Color(0xFF546E7A),
          circleBgColor: const Color(0xFFECEFF1),
          route: '/parking',
        ),
        _buildQuickActionCard(
          title: 'Maintenance',
          subtitle: 'New request',
          icon: Icons.construction_outlined,
          iconColor: const Color(0xFF43A047),
          circleBgColor: const Color(0xFFF1F8E9),
          route: '/maintenance',
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color circleBgColor,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Icon Background
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: circleBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const Spacer(),
            // Text Details
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketplaceCard() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/marketplace'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            // Shopping bag icon in orange/amber box
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFA726),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF4E342E),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Text Details
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marketplace',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Buy & sell within the community',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron arrow
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsCard() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/announcements'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            // Megaphone icon in rounded box
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF85B842),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: Color(0xFF1B3D00),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Text Details
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Announcements',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Elevator maintenance on floor 4...',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron arrow
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/calendar'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            // Calendar icon in slate blue box
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF90A4AE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF263238),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Text Details
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Check community events',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron arrow
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
