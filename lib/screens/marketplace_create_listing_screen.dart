// lib/screens/marketplace_create_listing_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';
import '../services/marketplace_service.dart';
import '../models/marketplace_model.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/shimmer_form_card.dart';

import '../widgets/responsive_mockup.dart';

class MarketplaceCreateListingScreen extends ConsumerStatefulWidget {
  const MarketplaceCreateListingScreen({super.key});

  @override
  ConsumerState<MarketplaceCreateListingScreen> createState() =>
      _MarketplaceCreateListingScreenState();
}

class _MarketplaceCreateListingScreenState
    extends ConsumerState<MarketplaceCreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedListingType = 'For Sale';
  String _selectedPropertyType = 'Apartment';
  String _selectedStatus = 'Available';
  int? _selectedBlockId;
  int? _selectedFloorId;
  int? _selectedUnitId;

  List<String> _selectedAmenities = [];
  List<File> _selectedImages = [];

  // Available options
  final List<String> _listingTypes = ['For Sale', 'For Rent'];
  final List<String> _propertyTypes = ['Apartment', 'Commercial'];
  final List<String> _statuses = [
    'Available',
    'Sold',
    'Pending',
    'Under Negotiation',
    'Rented',
  ];
  final List<String> _availableAmenities = [
    'Parking',
    'Garden',
    'Security',
    'Generator',
    'Water Tank',
    'Elevator',
    'Swimming Pool',
    'Gym',
    'Playground',
  ];

  List<PropertyBlock> _blocks = [];
  List<PropertyFloor> _floors = [];
  List<PropertyUnit> _units = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _isImageLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBlocks();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadBlocks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Please login to continue';
          _isLoading = false;
        });
        return;
      }

      final service = ref.read(marketplaceServiceProvider);
      final blocks = await service.getPropertyBlocks(token);

      setState(() {
        _blocks = blocks;
        _isLoading = false;
        if (blocks.isNotEmpty) {
          _selectedBlockId = blocks.first.id;
          _loadFloors(blocks.first.id);
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFloors(int blockId) async {
    setState(() {
      _isLoading = true;
      _selectedFloorId = null;
      _selectedUnitId = null;
      _floors = [];
      _units = [];
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Please login to continue';
          _isLoading = false;
        });
        return;
      }

      final service = ref.read(marketplaceServiceProvider);
      final floors = await service.getPropertyFloors(token, blockId);

      setState(() {
        _floors = floors;
        _isLoading = false;
        if (floors.isNotEmpty) {
          _selectedFloorId = floors.first.id;
          _loadUnits(blockId, floors.first.id);
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUnits(int blockId, int floorId) async {
    setState(() {
      _isLoading = true;
      _selectedUnitId = null;
      _units = [];
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Please login to continue';
          _isLoading = false;
        });
        return;
      }

      final service = ref.read(marketplaceServiceProvider);
      final units = await service.getPropertyUnits(
        token,
        blockId: blockId,
        floorId: floorId,
      );

      setState(() {
        _units = units;
        _isLoading = false;
        if (units.isNotEmpty) {
          _selectedUnitId = units.first.id;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImages() async {
    final status = await Permission.photos.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please allow photo access to select images'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Photo access permanently denied. Please enable in settings.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      openAppSettings();
      return;
    }

    setState(() {
      _isImageLoading = true;
    });

    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(limit: 5);

      if (images.isNotEmpty) {
        final List<File> files = images
            .map((xfile) => File(xfile.path))
            .toList();
        setState(() {
          _selectedImages = files;
          _isImageLoading = false;
        });
      } else {
        setState(() {
          _isImageLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });

      try {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          setState(() {
            _selectedImages = [File(image.path)];
          });
        }
      } catch (e2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e2'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.token;

      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Please login to continue';
          _isSubmitting = false;
        });
        return;
      }

      final service = ref.read(marketplaceServiceProvider);

      // STEP 1: Upload images to /media/upload
      List<String> uploadedImageUrls = [];
      try {
        uploadedImageUrls = await service.uploadImages(
          token: token,
          imageFiles: _selectedImages,
        );
        print('✅ Uploaded ${uploadedImageUrls.length} images');
      } catch (e) {
        setState(() {
          _errorMessage =
              'Failed to upload images: ${e.toString().replaceAll('Exception: ', '')}';
          _isSubmitting = false;
        });
        return;
      }

      // STEP 2: Create listing with image URLs
      final request = CreateListingRequest(
        title: _titleController.text.trim(),
        listingType: _selectedListingType,
        propertyType: _selectedPropertyType,
        status: _selectedStatus,
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        bedrooms: int.tryParse(_bedroomsController.text.trim()) ?? 0,
        bathrooms: int.tryParse(_bathroomsController.text.trim()) ?? 0,
        areaSqm: double.tryParse(_areaController.text.trim()) ?? 0,
        description: _descriptionController.text.trim(),
        amenities: _selectedAmenities,
        blockId: _selectedBlockId,
        floorId: _selectedFloorId,
        unitId: _selectedUnitId,
        images: uploadedImageUrls,
      );

      final listing = await service.createListing(
        token: token,
        request: request,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing created successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isSubmitting = false;
      });
    }
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (_selectedAmenities.contains(amenity)) {
        _selectedAmenities.remove(amenity);
      } else {
        _selectedAmenities.add(amenity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveMockup(
      child: _buildScreenContent(),
    );
  }

  Widget _buildScreenContent() {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        title: const Text(
          'New Listing',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D0F0C),
          ),
        ),
        backgroundColor: AppColors.screenBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0D0F0C),
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading && _blocks.isEmpty
          ? _buildShimmerForm()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _errorMessage = null),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Section: Basic Info
                    _buildSectionHeader('Basic Information'),
                    const SizedBox(height: 12),

                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                        label: 'Property Title',
                        hint: 'e.g., Modern Apartment in Block A',
                        icon: Icons.title,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a title'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // Listing Type & Property Type
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedListingType,
                            isExpanded: true,
                            decoration: _buildInputDecoration(
                              label: 'Listing Type',
                              icon: Icons.sell,
                            ),
                            items: _listingTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedListingType = value!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedPropertyType,
                            isExpanded: true,
                            decoration: _buildInputDecoration(
                              label: 'Property Type',
                              icon: Icons.home,
                            ),
                            items: _propertyTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedPropertyType = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Status
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      isExpanded: true,
                      decoration: _buildInputDecoration(
                        label: 'Status',
                        icon: Icons.flag,
                      ),
                      items: _statuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  status,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                    ),
                    const SizedBox(height: 20),

                    // Section: Property Details
                    _buildSectionHeader('Property Details'),
                    const SizedBox(height: 12),

                    // Price, Bedrooms
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              label: 'Price (ETB)',
                              icon: Icons.attach_money,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _bedroomsController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              label: 'Bedrooms',
                              icon: Icons.bed,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Bathrooms, Area
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bathroomsController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              label: 'Bathrooms',
                              icon: Icons.bathtub,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _areaController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              label: 'Area (sqm)',
                              icon: Icons.square_foot,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section: Location
                    if (_blocks.isNotEmpty) ...[
                      _buildSectionHeader('Location'),
                      const SizedBox(height: 12),

                      // Block
                      DropdownButtonFormField<int>(
                        value: _selectedBlockId,
                        isExpanded: true,
                        decoration: _buildInputDecoration(
                          label: 'Block',
                          icon: Icons.apartment,
                        ),
                        items: _blocks.map((block) {
                          return DropdownMenuItem(
                            value: block.id,
                            child: Text(
                              block.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedBlockId = value;
                              _loadFloors(value);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Floor
                      if (_floors.isNotEmpty)
                        DropdownButtonFormField<int>(
                          value: _selectedFloorId,
                          isExpanded: true,
                          decoration: _buildInputDecoration(
                            label: 'Floor',
                            icon: Icons.elevator,
                          ),
                          items: _floors.map((floor) {
                            return DropdownMenuItem(
                              value: floor.id,
                              child: Text(
                                floor.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedFloorId = value;
                                if (_selectedBlockId != null) {
                                  _loadUnits(_selectedBlockId!, value);
                                }
                              });
                            }
                          },
                        ),
                      if (_floors.isNotEmpty) const SizedBox(height: 14),

                      // Unit
                      if (_units.isNotEmpty)
                        DropdownButtonFormField<int>(
                          value: _selectedUnitId,
                          isExpanded: true,
                          decoration: _buildInputDecoration(
                            label: 'Unit',
                            icon: Icons.door_front_door,
                          ),
                          items: _units.map((unit) {
                            return DropdownMenuItem(
                              value: unit.id,
                              child: Text(
                                unit.code,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedUnitId = value!),
                        ),
                      if (_units.isNotEmpty) const SizedBox(height: 20),
                    ],

                    // Section: Description
                    _buildSectionHeader('Description'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration:
                          _buildInputDecoration(
                            label: 'Description',
                            hint: 'Describe the property in detail...',
                            icon: Icons.description,
                          ).copyWith(
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a description'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Section: Amenities
                    _buildSectionHeader('Amenities'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _availableAmenities.map((amenity) {
                        final isSelected = _selectedAmenities.contains(amenity);
                        return GestureDetector(
                          onTap: () => _toggleAmenity(amenity),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryGreen
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryGreen
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[400],
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  amenity,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Section: Photos
                    _buildSectionHeader('Photos'),
                    const SizedBox(height: 10),

                    // Image picker
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderDefault,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.photo_library,
                                    color: AppColors.primaryGreen,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Property Photos',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        _selectedImages.isEmpty
                                            ? 'Add up to 5 photos'
                                            : '${_selectedImages.length} photo${_selectedImages.length > 1 ? 's' : ''} selected',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isImageLoading)
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Image grid
                          if (_selectedImages.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _selectedImages.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final image = entry.value;
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          image: DecorationImage(
                                            image: FileImage(image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),

                          if (_selectedImages.isNotEmpty)
                            const Divider(height: 1, color: Color(0xFFF5F5F5)),

                          // Add photos button
                          GestureDetector(
                            onTap: _isImageLoading ? null : _pickImages,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _selectedImages.isEmpty
                                        ? Icons.add_photo_alternate
                                        : Icons.add,
                                    color: AppColors.primaryGreen,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _selectedImages.isEmpty
                                        ? 'Add Photos'
                                        : 'Add More Photos',
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitListing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Create Listing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildShimmerForm() {
    return ShimmerLoading(
      isLoading: true,
      shimmerChild: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Section
            _buildShimmerSectionHeader('Basic Information'),
            const SizedBox(height: 12),
            const ShimmerFormField(),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(child: ShimmerFormField()),
                const SizedBox(width: 12),
                const Expanded(child: ShimmerFormField()),
              ],
            ),
            const SizedBox(height: 14),
            const ShimmerFormField(),
            const SizedBox(height: 20),

            // Property Details Section
            _buildShimmerSectionHeader('Property Details'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: ShimmerFormField()),
                const SizedBox(width: 12),
                const Expanded(child: ShimmerFormField()),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(child: ShimmerFormField()),
                const SizedBox(width: 12),
                const Expanded(child: ShimmerFormField()),
              ],
            ),
            const SizedBox(height: 20),

            // Location Section
            _buildShimmerSectionHeader('Location'),
            const SizedBox(height: 12),
            const ShimmerFormField(),
            const SizedBox(height: 14),
            const ShimmerFormField(),
            const SizedBox(height: 14),
            const ShimmerFormField(),
            const SizedBox(height: 20),

            // Description Section
            _buildShimmerSectionHeader('Description'),
            const SizedBox(height: 12),
            const ShimmerFormField(height: 100),
            const SizedBox(height: 20),

            // Amenities Section
            _buildShimmerSectionHeader('Amenities'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(6, (index) {
                return Container(
                  width: 80,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Photos Section
            _buildShimmerSectionHeader('Photos'),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 120,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button Shimmer
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      child: Container(), // Not used during loading
    );
  }

  Widget _buildShimmerSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 150,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF10B981);
      case 'sold':
        return const Color(0xFFEF4444);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'under negotiation':
        return const Color(0xFF8B5CF6);
      case 'rented':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
