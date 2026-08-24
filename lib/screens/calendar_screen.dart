// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/colors.dart';
import '../providers/calendar_event_provider.dart';
import '../models/calendar_event_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/shimmer_calendar_grid.dart';
import '../widgets/shimmer_event_card.dart';
import '../widgets/responsive_mockup.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with WidgetsBindingObserver {
  DateTime _currentMonth = DateTime.now();
  bool _showAllEvents = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back to foreground
      ref.refresh(calendarEventsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveMockup(
      child: _buildScreenContent(context),
    );
  }

  Widget _buildScreenContent(BuildContext context) {
    final eventsAsyncValue = ref.watch(calendarEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: eventsAsyncValue.when(
                data: (events) => RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(calendarEventsProvider);
                  },
                  color: AppColors.primaryGreen,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _buildMonthSelectorRow(),
                        const SizedBox(height: 16),
                        _buildCalendarGridCard(events),
                        const SizedBox(height: 24),
                        _buildUpcomingEventsHeader(events),
                        const SizedBox(height: 14),
                        _buildEventsList(events),
                        const SizedBox(height: 24),
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
                          'Error loading events: $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ref.refresh(calendarEventsProvider),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Always show Home as selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/bills');
          } else if (index == 2) {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/parking');
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
            // Month Selector Shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Calendar Grid Shimmer
            const ShimmerCalendarGrid(),
            const SizedBox(height: 24),
            // Upcoming Events Header Shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Event Cards Shimmer
            ...List.generate(3, (index) => const ShimmerEventCard()),
            const SizedBox(height: 24),
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

  Widget _buildMonthSelectorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMonthYearString(_currentMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D0F0C),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(
                    _currentMonth.year,
                    _currentMonth.month - 1,
                  );
                });
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Color(0xFF0D0F0C),
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(
                    _currentMonth.year,
                    _currentMonth.month + 1,
                  );
                });
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Color(0xFF0D0F0C),
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendarGridCard(List<CalendarEvent> events) {
    final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    // Get event days from the API for the current month
    final Set<int> eventDays = events
        .where((event) {
          final eventDate = DateTime.parse(event.date);
          return eventDate.year == _currentMonth.year &&
              eventDate.month == _currentMonth.month;
        })
        .map((event) {
          final eventDate = DateTime.parse(event.date);
          return eventDate.day;
        })
        .toSet();

    // Get the first day of the month and number of days
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstWeekday = firstDayOfMonth.weekday; // 1=Monday, 7=Sunday

    // Build calendar days
    final List<Map<String, dynamic>> calendarDays = [];

    // Add days from previous month to fill the first week
    final daysInPrevMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      0,
    ).day;
    final startOffset = firstWeekday % 7; // Convert to Sunday-based (0=Sunday)

    for (int i = startOffset - 1; i >= 0; i--) {
      calendarDays.add({'day': daysInPrevMonth - i, 'isCurrentMonth': false});
    }

    // Add current month days
    for (int day = 1; day <= daysInMonth; day++) {
      calendarDays.add({'day': day, 'isCurrentMonth': true});
    }

    // Add days from next month to complete the grid
    final remainingDays = (7 - (calendarDays.length % 7)) % 7;
    for (int day = 1; day <= remainingDays; day++) {
      calendarDays.add({'day': day, 'isCurrentMonth': false});
    }

    // Get today's date for highlighting
    final today = DateTime.now();
    final bool isCurrentMonthToday =
        (today.year == _currentMonth.year &&
        today.month == _currentMonth.month);

    return Container(
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
        children: [
          // Weekday Labels
          Row(
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Days grid
          Wrap(
            spacing: 0,
            runSpacing: 8,
            children: calendarDays.map((dayInfo) {
              final int day = dayInfo['day'];
              final bool isCurrentMonth = dayInfo['isCurrentMonth'];
              final bool hasEvent = eventDays.contains(day);
              final bool isToday =
                  isCurrentMonth && isCurrentMonthToday && day == today.day;
              final bool isSelected = false; // Remove hardcoded selection

              return SizedBox(
                width: (MediaQuery.of(context).size.width - 72) / 7.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primaryGreen,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isToday
                                ? Colors.white
                                : isCurrentMonth
                                ? AppColors.textPrimary
                                : AppColors.textDisabled,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Green dot directly under the day number
                    Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasEvent
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsHeader(List<CalendarEvent> events) {
    // Count events for current month
    final filteredEvents = events.where((event) {
      final eventDate = DateTime.parse(event.date);
      return eventDate.year == _currentMonth.year &&
          eventDate.month == _currentMonth.month;
    }).toList();

    // Show "View All" only if there are more than 4 events
    final bool showViewAll = filteredEvents.length > 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D0F0C),
          ),
        ),
        Row(
          children: [
            if (showViewAll)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAllEvents = !_showAllEvents;
                  });
                },
                child: Text(
                  _showAllEvents ? 'Show Less' : 'View All',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventsList(List<CalendarEvent> events) {
    // Filter events for current month
    final filteredEvents = events.where((event) {
      final eventDate = DateTime.parse(event.date);
      return eventDate.year == _currentMonth.year &&
          eventDate.month == _currentMonth.month;
    }).toList();

    // Show all events if _showAllEvents is true, otherwise show only first 4
    final displayEvents = _showAllEvents
        ? filteredEvents
        : (filteredEvents.length > 4
              ? filteredEvents.sublist(0, 4)
              : filteredEvents);

    if (displayEvents.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'No events for this month',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: displayEvents.map((event) {
        // Parse date
        final eventDate = DateTime.parse(event.date);
        final day = eventDate.day.toString().padLeft(2, '0');
        final monthName = _getMonthAbbreviation(eventDate.month);

        // Format time safely (handle null event.time)
        String formattedTime = 'All Day';
        if (event.time != null && event.time!.isNotEmpty) {
          try {
            String timeStr = event.time!;
            if (timeStr.length >= 5) {
              timeStr = timeStr.substring(0, 5);
            }

            // Format time to 12-hour format
            final timeParts = timeStr.split(':');
            if (timeParts.length >= 2) {
              int hour = int.parse(timeParts[0]);
              final minute = timeParts[1];
              final amPm = hour >= 12 ? 'PM' : 'AM';
              if (hour > 12) hour -= 12;
              if (hour == 0) hour = 12;
              formattedTime = '$hour:$minute $amPm';
            }
          } catch (e) {
            formattedTime = event.time!;
          }
        }

        // Get category badge color
        final badgeInfo = _getCategoryBadgeInfo(event.category);

        return GestureDetector(
          onTap: () => _showEventDetailsDialog(event),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Box
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF85B842), // Lime green box
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        monthName,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Event Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Category Badge row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badgeInfo['bgColor'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  badgeInfo['icon'],
                                  color: badgeInfo['textColor'],
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.category,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: badgeInfo['textColor'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Time info
                      Text(
                        '$formattedTime • ${event.property?.name ?? 'Green Park Properties'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showEventDetailsDialog(CalendarEvent event) {
    final eventDate = DateTime.parse(event.date);
    final monthName = _getMonthAbbreviation(eventDate.month);
    final day = eventDate.day.toString().padLeft(2, '0');
    final year = eventDate.year;

    // Format time safely
    String formattedTime = 'All Day';
    if (event.time != null && event.time!.isNotEmpty) {
      try {
        String timeStr = event.time!;
        if (timeStr.length >= 5) {
          timeStr = timeStr.substring(0, 5);
        }
        final timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          int hour = int.parse(timeParts[0]);
          final minute = timeParts[1];
          final amPm = hour >= 12 ? 'PM' : 'AM';
          if (hour > 12) hour -= 12;
          if (hour == 0) hour = 12;
          formattedTime = '$hour:$minute $amPm';
        }
      } catch (e) {
        formattedTime = event.time!;
      }
    }

    final badgeInfo = _getCategoryBadgeInfo(event.category);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF85B842), Color(0xFF6A9E3A)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Date display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$monthName $day, $year',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      event.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            badgeInfo['icon'],
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time and location
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: AppColors.primaryGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                event.property?.name ?? 'Green Park Properties',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    Container(height: 1, color: AppColors.borderDefault),
                    const SizedBox(height: 16),
                    // Description section
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.screenBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderDefault,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Created by
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primaryGreen.withValues(
                            alpha: 0.1,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.primaryGreen,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.createdBy?.name ?? 'Admin',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Created by',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Close button
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
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  Map<String, dynamic> _getCategoryBadgeInfo(String category) {
    switch (category.toLowerCase()) {
      case 'meeting':
        return {
          'bgColor': const Color(0xFFC5E1A5),
          'textColor': AppColors.primaryGreen,
          'icon': Icons.people_outline,
        };
      case 'event':
        return {
          'bgColor': const Color(0xFFFFEBEC),
          'textColor': const Color(0xFFD32F2F),
          'icon': Icons.event_available_outlined,
        };
      case 'maintenance':
        return {
          'bgColor': const Color(0xFFE3F2FD),
          'textColor': const Color(0xFF1E88E5),
          'icon': Icons.construction_outlined,
        };
      default:
        return {
          'bgColor': const Color(0xFFF5F5F5),
          'textColor': const Color(0xFF757575),
          'icon': Icons.event_note_outlined,
        };
    }
  }
}
