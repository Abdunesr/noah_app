// lib/screens/water_meter/add_water_meter_reading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/water_meter_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/marketplace_service.dart';
import '../../providers/marketplace_provider.dart';
import '../../models/marketplace_model.dart';
import '../../models/water_meter_model.dart';
import '../../utils/colors.dart';
import '../../widgets/app_snackbars.dart';

class AddWaterMeterReadingScreen extends ConsumerStatefulWidget {
  const AddWaterMeterReadingScreen({super.key});

  @override
  ConsumerState<AddWaterMeterReadingScreen> createState() =>
      _AddWaterMeterReadingScreenState();
}

class _AddWaterMeterReadingScreenState
    extends ConsumerState<AddWaterMeterReadingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Fallback property ID if none is resolved dynamically
  static const int _fixedPropertyId = 1;

  // Controllers
  final _previousReadingController = TextEditingController();
  final _currentReadingController = TextEditingController();
  final _notesController = TextEditingController();
  final _readerEmployeeController = TextEditingController();

  // Selected values
  int? _selectedBlockId;
  int? _selectedFloorId;
  int? _selectedUnitId;

  DateTime _selectedDate = DateTime.now();
  String _selectedMonth = '';

  // Lists
  List<PropertyBlock> _blocks = [];
  List<PropertyFloor> _floors = [];
  List<PropertyUnit> _units = [];

  bool _isLoadingBlocks = false;
  bool _isLoadingFloors = false;
  bool _isLoadingUnits = false;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());
    _loadBlocks();
  }

  @override
  void dispose() {
    _previousReadingController.dispose();
    _currentReadingController.dispose();
    _notesController.dispose();
    _readerEmployeeController.dispose();
    super.dispose();
  }

  int get _selectedPropertyId {
    if (_selectedBlockId == null || _blocks.isEmpty) return _fixedPropertyId;
    try {
      final block = _blocks.firstWhere((b) => b.id == _selectedBlockId);
      return block.propertyId;
    } catch (_) {
      return _fixedPropertyId;
    }
  }

  Future<void> _loadBlocks() async {
    setState(() {
      _isLoadingBlocks = true;
      _blocks = [];
      _selectedBlockId = null;
      _floors = [];
      _selectedFloorId = null;
      _units = [];
      _selectedUnitId = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;
      if (token != null && token.isNotEmpty) {
        final service = ref.read(marketplaceServiceProvider);
        final blocks = await service.getPropertyBlocks(token);
        
        setState(() {
          _blocks = blocks;
          _isLoadingBlocks = false;
          if (blocks.isNotEmpty) {
            _selectedBlockId = blocks.first.id;
            _loadFloors(blocks.first.id);
          }
        });
      }
    } catch (e) {
      setState(() => _isLoadingBlocks = false);
      if (mounted) {
        AppSnackBars.showError(
          context,
          title: 'Error',
          message: 'Failed to load blocks: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  Future<void> _loadFloors(int blockId) async {
    setState(() {
      _isLoadingFloors = true;
      _floors = [];
      _selectedFloorId = null;
      _units = [];
      _selectedUnitId = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;
      if (token != null && token.isNotEmpty) {
        final service = ref.read(marketplaceServiceProvider);
        final floors = await service.getPropertyFloors(token, blockId);
        setState(() {
          _floors = floors;
          _isLoadingFloors = false;
          if (floors.isNotEmpty) {
            _selectedFloorId = floors.first.id;
            _loadUnits(blockId: blockId, floorId: floors.first.id);
          } else {
            _loadUnits(blockId: blockId);
          }
        });
      }
    } catch (e) {
      setState(() => _isLoadingFloors = false);
      if (mounted) {
        AppSnackBars.showError(
          context,
          title: 'Error',
          message: 'Failed to load floors: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  Future<void> _loadUnits({int? blockId, int? floorId}) async {
    setState(() {
      _isLoadingUnits = true;
      _units = [];
      _selectedUnitId = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;
      if (token != null && token.isNotEmpty) {
        final service = ref.read(marketplaceServiceProvider);
        final units = await service.getPropertyUnits(
          token,
          blockId: blockId,
          floorId: floorId,
        );
        setState(() {
          _units = units;
          _isLoadingUnits = false;
          if (units.isNotEmpty) {
            _selectedUnitId = units.first.id;
          }
        });
      }
    } catch (e) {
      setState(() => _isLoadingUnits = false);
      if (mounted) {
        AppSnackBars.showError(
          context,
          title: 'Error',
          message: 'Failed to load units: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  Future<void> _submitReading() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBlockId == null) {
        AppSnackBars.showWarning(
          context,
          title: 'Warning',
          message: 'Please select a block',
        );
        return;
      }

      if (_selectedUnitId == null) {
        AppSnackBars.showWarning(
          context,
          title: 'Warning',
          message: 'Please select a unit',
        );
        return;
      }

      try {
        final request = WaterMeterReadingRequest(
          propertyId: _selectedPropertyId,
          unitId: _selectedUnitId!,
          month: _selectedMonth,
          previousReading: double.parse(_previousReadingController.text.trim()),
          currentReading: double.parse(_currentReadingController.text.trim()),
          readingDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
          readerEmployee: _readerEmployeeController.text.trim().isEmpty
              ? null
              : _readerEmployeeController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

        final notifier = ref.read(waterMeterProvider.notifier);
        final success = await notifier.createReading(request);

        if (success && mounted) {
          AppSnackBars.showSuccess(
            context,
            title: 'Success',
            message: 'Reading recorded successfully! 🎉',
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          AppSnackBars.showError(
            context,
            title: 'Error',
            message: e.toString().replaceAll('Exception: ', ''),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterMeterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Add Meter Reading',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),

              // Card 1: Location details
              _buildSectionCard(
                title: 'Property Location',
                icon: Icons.location_on_outlined,
                children: [
                  _buildBlockDropdown(),
                  const SizedBox(height: 16),
                  _buildFloorDropdown(),
                  const SizedBox(height: 16),
                  _buildUnitDropdown(),
                ],
              ),
              const SizedBox(height: 20),

              // Card 2: Reading Metrics
              _buildSectionCard(
                title: 'Reading Information',
                icon: Icons.speed_outlined,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildMonthSelector()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDateSelector()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _previousReadingController,
                    label: 'Previous Reading',
                    hint: 'e.g. 0',
                    icon: Icons.history_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter previous reading';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _currentReadingController,
                    label: 'Current Reading',
                    hint: 'e.g. 520',
                    icon: Icons.water_drop_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter current reading';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Card 3: Additional Notes
              _buildSectionCard(
                title: 'Extra Details',
                icon: Icons.assignment_outlined,
                children: [
                  _buildInputField(
                    controller: _readerEmployeeController,
                    label: 'Reader Employee (Optional)',
                    hint: 'Enter employee name',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _notesController,
                    label: 'Notes (Optional)',
                    hint: 'Add reading details/conditions',
                    icon: Icons.chat_bubble_outline,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isSubmitting ? null : _submitReading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 1,
                    shadowColor: AppColors.primaryGreen.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save & Submit Reading',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.opacity,
              color: AppColors.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Record New Usage',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Fill in current meter details for logging.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBlockDropdown() {
    return DropdownButtonFormField<int>(
      decoration: _buildDropdownDecoration('Block *', Icons.grid_view_outlined),
      value: _selectedBlockId,
      isExpanded: true,
      items: _isLoadingBlocks
          ? [
              const DropdownMenuItem(
                value: null,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ]
          : [
              const DropdownMenuItem(value: null, child: Text('Select Block')),
              ..._blocks.map((block) {
                return DropdownMenuItem(
                  value: block.id,
                  child: Text(block.name, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
            ],
      onChanged: _isLoadingBlocks || _blocks.isEmpty
          ? null
          : (value) {
              setState(() {
                _selectedBlockId = value;
                _selectedFloorId = null;
                _selectedUnitId = null;
                _floors = [];
                _units = [];
              });
              if (value != null) {
                _loadFloors(value);
              }
            },
      validator: (value) {
        if (value == null && !_isLoadingBlocks) {
          return 'Please select a block';
        }
        return null;
      },
    );
  }

  Widget _buildFloorDropdown() {
    return DropdownButtonFormField<int>(
      decoration: _buildDropdownDecoration(
        'Floor (Optional)',
        Icons.layers_outlined,
      ),
      value: _selectedFloorId,
      isExpanded: true,
      items: _isLoadingFloors
          ? [
              const DropdownMenuItem(
                value: null,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ]
          : [
              const DropdownMenuItem(value: null, child: Text('Select Floor')),
              ..._floors.map((floor) {
                return DropdownMenuItem(
                  value: floor.id,
                  child: Text(
                    floor.label,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ],
      onChanged: _isLoadingFloors || _floors.isEmpty
          ? null
          : (value) {
              setState(() {
                _selectedFloorId = value;
                _selectedUnitId = null;
                _units = [];
              });
              if (value != null) {
                _loadUnits(blockId: _selectedBlockId, floorId: value);
              } else {
                _loadUnits(blockId: _selectedBlockId);
              }
            },
    );
  }

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<int>(
      decoration: _buildDropdownDecoration('Unit *', Icons.door_front_door_outlined),
      value: _selectedUnitId,
      isExpanded: true,
      items: _isLoadingUnits
          ? [
              const DropdownMenuItem(
                value: null,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ]
          : [
              const DropdownMenuItem(value: null, child: Text('Select Unit')),
              ..._units.map((unit) {
                return DropdownMenuItem(
                  value: unit.id,
                  child: Text(
                    '${unit.code} (${unit.type})',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ],
      onChanged: _isLoadingUnits || _units.isEmpty
          ? null
          : (value) {
              setState(() {
                _selectedUnitId = value;
              });
            },
      validator: (value) {
        if (value == null && !_isLoadingUnits) {
          return 'Please select a unit';
        }
        return null;
      },
    );
  }

  InputDecoration _buildDropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 18),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return GestureDetector(
      onTap: _selectMonth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Month *',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: AppColors.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedMonth,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reading Date *',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.event,
                  color: AppColors.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 18),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _selectMonth() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month),
      firstDate: DateTime(2020),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      setState(() {
        _selectedMonth = DateFormat('yyyy-MM').format(selected);
      });
    }
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }
}
