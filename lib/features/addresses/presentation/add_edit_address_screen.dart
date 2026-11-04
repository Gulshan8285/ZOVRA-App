import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../../data/models/address_model.dart';
import '../providers/address_provider.dart';

class AddEditAddressScreen extends ConsumerStatefulWidget {
  final String? addressId;

  const AddEditAddressScreen({super.key, this.addressId});

  @override
  ConsumerState<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedTag = 'Home';
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(text: 'Gurugram');
  final TextEditingController _stateController = TextEditingController(text: 'Haryana');
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {
      final addresses = ref.read(addressProvider).addresses;
      final existing = addresses.where((a) => a.id == widget.addressId).firstOrNull;
      if (existing != null) {
        _selectedTag = existing.tag;
        _houseNoController.text = existing.houseNumber;
        _buildingController.text = existing.buildingName;
        _streetController.text = existing.streetLocality;
        _cityController.text = existing.city;
        _stateController.text = existing.state;
        _pincodeController.text = existing.pincode;
        _phoneController.text = existing.contactPhone;
        _instructionsController.text = existing.specialInstructions;
        _isDefault = existing.isDefault;
      }
    }
  }

  @override
  void dispose() {
    _houseNoController.dispose();
    _buildingController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _fillGPSLocation() {
    setState(() {
      _houseNoController.text = 'Villa 42';
      _buildingController.text = 'Aralias Super Luxury Residences';
      _streetController.text = 'Golf Course Road, Sector 42';
      _cityController.text = 'Gurugram';
      _stateController.text = 'Haryana';
      _pincodeController.text = '122002';
      _instructionsController.text = 'Security intercom at gate 2.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address autofilled from current GPS location.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final notifier = ref.read(addressProvider.notifier);
    if (widget.addressId != null) {
      final updated = AddressModel(
        id: widget.addressId!,
        tag: _selectedTag,
        houseNumber: _houseNoController.text.trim(),
        buildingName: _buildingController.text.trim(),
        streetLocality: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        contactPhone: _phoneController.text.trim(),
        specialInstructions: _instructionsController.text.trim(),
        isDefault: _isDefault,
      );
      await notifier.updateAddress(updated);
    } else {
      await notifier.addAddress(
        tag: _selectedTag,
        houseNumber: _houseNoController.text.trim(),
        buildingName: _buildingController.text.trim(),
        streetLocality: _streetController.text.trim(),
        city: _cityController.text.trim(),
        stateName: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        contactPhone: _phoneController.text.trim(),
        specialInstructions: _instructionsController.text.trim(),
        isDefault: _isDefault,
      );
    }

    setState(() => _isSaving = false);
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.addressId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Address' : 'Add New Address',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use GPS Location Button
              InkWell(
                onTap: _fillGPSLocation,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Autofill from Current GPS Location',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Address Tag
              Text(
                'Save As',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTagOption('Home', Icons.home_rounded),
                  const SizedBox(width: 10),
                  _buildTagOption('Office', Icons.apartment_rounded),
                  const SizedBox(width: 10),
                  _buildTagOption('Other', Icons.location_on_rounded),
                ],
              ),

              const SizedBox(height: 20),

              // House / Flat No
              TextFormField(
                controller: _houseNoController,
                decoration: const InputDecoration(
                  labelText: 'House / Flat / Villa Number *',
                  hintText: 'e.g. Flat 402, Tower B',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter house/flat number'
                    : null,
              ),

              const SizedBox(height: 14),

              // Apartment / Building
              TextFormField(
                controller: _buildingController,
                decoration: const InputDecoration(
                  labelText: 'Apartment / Society Name *',
                  hintText: 'e.g. The Palm Springs Residences',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter apartment/society name'
                    : null,
              ),

              const SizedBox(height: 14),

              // Street / Locality
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street / Locality / Sector *',
                  hintText: 'e.g. Golf Course Road, Sector 54',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter street or locality'
                    : null,
              ),

              const SizedBox(height: 14),

              // City & State Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City *',
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Enter city'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State *',
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Enter state'
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // PIN Code
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'PIN Code *',
                  hintText: 'e.g. 122002',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter PIN code';
                  if (val.trim().length != 6) return 'Must be 6 digits';
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Contact Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Alternate Contact Phone (Optional)',
                  hintText: '+91 98765 43210',
                ),
              ),

              const SizedBox(height: 14),

              // Special Instructions
              TextFormField(
                controller: _instructionsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Delivery Instructions (Optional)',
                  hintText: 'e.g. Landmark, service lift access, dog at home',
                ),
              ),

              const SizedBox(height: 16),

              // Default Switch
              SwitchListTile(
                value: _isDefault,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Set as default address',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  'This address will be pre-selected on checkout',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                ),
                onChanged: (val) => setState(() => _isDefault = val),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.borderLight)),
          ),
          child: ZovraButton(
            text: isEditing ? 'Update Address' : 'Save Address',
            isLoading: _isSaving,
            onPressed: _save,
          ),
        ),
      ),
    );
  }

  Widget _buildTagOption(String tag, IconData icon) {
    final isSelected = _selectedTag == tag;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTag = tag),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                tag,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

