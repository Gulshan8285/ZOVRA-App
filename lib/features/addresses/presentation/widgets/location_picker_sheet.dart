import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/zovra_button.dart';
import '../../providers/address_provider.dart';

class LocationPickerSheet extends ConsumerStatefulWidget {
  const LocationPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LocationPickerSheet(),
    );
  }

  @override
  ConsumerState<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends ConsumerState<LocationPickerSheet> {
  bool _isLocating = false;

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      await ref.read(addressProvider.notifier).addAddress(
            tag: 'Home',
            houseNumber: 'Plot 78, 2nd Floor',
            buildingName: 'Magnolias Enclave',
            streetLocality: 'Golf Course Extension Road',
            city: 'Gurugram',
            stateName: 'Haryana',
            pincode: '122018',
            isDefault: true,
          );
      setState(() => _isLocating = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated to current GPS address.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    final addresses = addressState.addresses;
    final selected = addressState.selectedAddress;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Delivery Address',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Use Current Location Button
          InkWell(
            onTap: _isLocating ? null : _useCurrentLocation,
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
                  _isLocating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : const Icon(Icons.my_location_rounded,
                          color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use Current Location',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          'Detect via GPS (Sector 54, Gurugram)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.primary, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            'SAVED ADDRESSES',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          // List of saved addresses
          if (addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No saved addresses yet',
                  style: GoogleFonts.inter(color: AppColors.textMuted),
                ),
              ),
            )
          else
            ...addresses.map((addr) {
              final isSelected = selected?.id == addr.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight.withOpacity(0.4) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  onTap: () {
                    ref.read(addressProvider.notifier).selectAddress(addr);
                    Navigator.of(context).pop();
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      addr.tag == 'Home'
                          ? Icons.home_rounded
                          : (addr.tag == 'Office'
                              ? Icons.apartment_rounded
                              : Icons.location_on_rounded),
                      size: 20,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        addr.tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (addr.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    addr.fullAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                ),
              );
            }),

          const SizedBox(height: 12),

          // Add New Address Button
          ZovraButton(
            text: '+ Add New Address',
            variant: ZovraButtonVariant.outline,
            height: 48,
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/addresses/add');
            },
          ),
        ],
      ),
    );
  }
}

