// lib/screens/water_meter/water_meter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/water_meter_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import '../../models/water_meter_model.dart';
import 'add_water_meter_reading_screen.dart';
import '../../widgets/app_loading_indicators.dart';
import '../../widgets/app_snackbars.dart';

class WaterMeterScreen extends ConsumerStatefulWidget {
  const WaterMeterScreen({super.key});

  @override
  ConsumerState<WaterMeterScreen> createState() => _WaterMeterScreenState();
}

class _WaterMeterScreenState extends ConsumerState<WaterMeterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(waterMeterProvider.notifier).loadReadings(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterMeterProvider);
    final notifier = ref.read(waterMeterProvider.notifier);
    final isWaterReader = ref.watch(authProvider).user?.isWaterReader ?? false;

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        automaticallyImplyLeading: !isWaterReader,
        title: const Text(
          'Water Meter Readings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D0F0C),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF0D0F0C)),
            onPressed: () {
              notifier.loadReadings(refresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Add Reading Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddWaterMeterReadingScreen(),
                  ),
                ).then((_) {
                  // Refresh when coming back
                  notifier.loadReadings(refresh: true);
                });
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add New Reading',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: state.isLoading && state.readings.isEmpty
                ? const AppShimmerListPlaceholder()
                : state.errorMessage != null
                ? _buildErrorWidget(state.errorMessage!)
                : state.readings.isEmpty
                ? _buildEmptyWidget()
                : _buildReadingsList(state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error loading readings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(waterMeterProvider.notifier).loadReadings(refresh: true);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.water_drop, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No readings recorded',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button above to add your first reading',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingsList(
    WaterMeterState state,
    WaterMeterNotifier notifier,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.readings.length + (state.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.readings.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AppSpinner(size: 24),
          );
        }

        final reading = state.readings[index];
        return _buildReadingCard(reading, notifier);
      },
    );
  }

  Widget _buildReadingCard(
    WaterMeterReading reading,
    WaterMeterNotifier notifier,
  ) {
    final unitInfo = reading.unit != null
        ? '${reading.unit!.code} (${reading.unit!.type})'
        : 'Unit #${reading.unitId}';
    final blockInfo = reading.block != null
        ? 'Block ${reading.block!.name}'
        : '';
    final floorInfo = reading.floor != null ? '${reading.floor!.label}' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(reading.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(reading.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  reading.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(reading.status),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                DateFormat(
                  'MMM yyyy',
                ).format(DateTime.parse('${reading.month}-01')),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Unit Info
          Text(
            unitInfo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          if (blockInfo.isNotEmpty || floorInfo.isNotEmpty)
            Text(
              [blockInfo, floorInfo].where((s) => s.isNotEmpty).join(' • '),
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          const SizedBox(height: 12),

          // Readings
          Row(
            children: [
              _buildReadingItem('Previous', reading.previousReading),
              const SizedBox(width: 16),
              _buildReadingItem('Current', reading.currentReading),
              const SizedBox(width: 16),
              _buildReadingItem(
                'Consumption',
                reading.consumption,
                isHighlighted: true,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Notes & Actions
          if (reading.notes != null && reading.notes!.isNotEmpty) ...[
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.note_outlined, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    reading.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (reading.status == 'draft') ...[
                IconButton(
                  icon: Icon(
                    Icons.verified_outlined,
                    size: 18,
                    color: AppColors.primaryGreen,
                  ),
                  onPressed: () {
                    _showVerifyDialog(context, reading.id, notifier);
                  },
                  tooltip: 'Verify Reading',
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red[300],
                  ),
                  onPressed: () {
                    _showDeleteDialog(context, reading.id, notifier);
                  },
                  tooltip: 'Delete Reading',
                ),
              ],
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  _showReadingDetails(context, reading);
                },
                tooltip: 'View Details',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadingItem(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isHighlighted ? AppColors.primaryGreen : Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return AppColors.primaryGreen;
      case 'draft':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showVerifyDialog(
    BuildContext context,
    int id,
    WaterMeterNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Verify Reading'),
        content: const Text(
          'Are you sure you want to verify this meter reading? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await notifier.verifyReading(id);
              if (success && mounted) {
                AppSnackBars.showSuccess(
                  context,
                  title: 'Success',
                  message: 'Reading verified successfully',
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    int id,
    WaterMeterNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Reading'),
        content: const Text(
          'Are you sure you want to delete this meter reading? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await notifier.deleteReading(id);
              if (success && mounted) {
                AppSnackBars.showSuccess(
                  context,
                  title: 'Success',
                  message: 'Reading deleted successfully',
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showReadingDetails(BuildContext context, WaterMeterReading reading) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Reading Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      _buildDetailRow('ID', '#${reading.id}'),
                      _buildDetailRow(
                        'Month',
                        DateFormat(
                          'MMMM yyyy',
                        ).format(DateTime.parse('${reading.month}-01')),
                      ),
                      _buildDetailRow('Status', reading.status.toUpperCase()),
                      _buildDetailRow(
                        'Property ID',
                        reading.propertyId.toString(),
                      ),
                      _buildDetailRow('Block', reading.block?.name ?? 'N/A'),
                      _buildDetailRow('Floor', reading.floor?.label ?? 'N/A'),
                      _buildDetailRow('Unit', reading.unit?.code ?? 'N/A'),
                      _buildDetailRow('Unit Type', reading.unit?.type ?? 'N/A'),
                      _buildDetailRow(
                        'Previous Reading',
                        reading.previousReading,
                      ),
                      _buildDetailRow(
                        'Current Reading',
                        reading.currentReading,
                      ),
                      _buildDetailRow('Consumption', reading.consumption),
                      _buildDetailRow(
                        'Reader',
                        reading.readerEmployee ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Reading Date',
                        DateFormat('dd/MM/yyyy').format(reading.readingDate),
                      ),
                      if (reading.notes != null)
                        _buildDetailRow('Notes', reading.notes!),
                      if (reading.submittedBy != null) ...[
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Submitted By',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reading.submittedBy!.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          reading.submittedBy!.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}
