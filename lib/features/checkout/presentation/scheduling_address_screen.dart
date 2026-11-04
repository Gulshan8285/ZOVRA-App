import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../addresses/presentation/widgets/location_picker_sheet.dart';
import '../../addresses/providers/address_provider.dart';
import '../../cart/providers/cart_provider.dart';

class SchedulingAddressScreen extends ConsumerStatefulWidget {
  const SchedulingAddressScreen({super.key});

  @override
  ConsumerState<SchedulingAddressScreen> createState() =>
      _SchedulingAddressScreenState();
}

class _SchedulingAddressScreenState extends ConsumerState<SchedulingAddressScreen> {
  late DateTime _selectedDate;
  late String _selectedSlot;
  final TextEditingController _instructionsController = TextEditingController();

  final List<DateTime> _dates = DateTimeUtils.getUpcomingDays(7);
  final List<String> _timeSlots = DateTimeUtils.getStandardTimeSlots();

  @override
  void initState() {
    super.initState();
    _selectedDate = _dates.first;
    _selectedSlot = _timeSlots[1]; // default 11:00 AM - 12:30 PM
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);
    final selectedAddress = addressState.selectedAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Schedule & Location',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderGlass.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Step 1 of 2: Pick date, time & confirm address',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Select Service Date
            Text(
              'Select Service Date',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 74,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  final isSelected = DateUtils.isSameDay(date, _selectedDate);
                  final isToday = index == 0;
                  final isTomorrow = index == 1;

                  String dayLabel = DateFormat('EEE').format(date);
                  if (isToday) dayLabel = 'Today';
                  if (isTomorrow) dayLabel = 'Tomorrow';

                  return InkWell(
                    onTap: () => setState(() => _selectedDate = date),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 68,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceGlassCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderGlass.withOpacity(0.35),
                          width: 1.2,
                        ),
                        boxShadow: isSelected ? AppColors.electricGlow : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.textOnPrimary : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d').format(date),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? AppColors.textOnPrimary : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Select Available Time Slot
            Text(
              'Select Preferred Time Slot',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedSlot == slot;
                return InkWell(
                  onTap: () => setState(() => _selectedSlot = slot),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.borderGlass.withOpacity(0.35),
                        width: 1.2,
                      ),
                      boxShadow: isSelected ? AppColors.electricGlow : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          slot,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppColors.textOnPrimary : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Confirm Delivery Address Card
            Text(
              'Service Delivery Address',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderGlass.withOpacity(0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            selectedAddress?.tag == 'Home'
                                ? Icons.home_rounded
                                : (selectedAddress?.tag == 'Office'
                                    ? Icons.apartment_rounded
                                    : Icons.location_on_rounded),
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            selectedAddress?.tag ?? 'Home',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => LocationPickerSheet.show(context),
                        child: const Text('Change Address', style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    selectedAddress?.fullAddress ?? 'No address selected',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  if (selectedAddress?.contactPhone.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Contact: ${selectedAddress!.contactPhone}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Special Instructions Field
            Text(
              'Special Instructions for Partner (Optional)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'e.g. Ring doorbell twice, service elevator near lobby...',
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Bar to proceed to payment
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceGlass,
            border: Border(top: BorderSide(color: AppColors.borderGlass.withOpacity(0.35))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CurrencyFormatter.format(cartState.finalTotal),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${DateFormat('d MMM').format(_selectedDate)}, ${_selectedSlot.split('-').first.trim()}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ZovraButton(
                  text: 'Proceed to Payment',
                  icon: const Icon(Icons.lock_rounded, color: AppColors.textOnPrimary, size: 18),
                  onPressed: () {
                    if (selectedAddress == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an address.'),
                          backgroundColor: AppColors.warning,
                        ),
                      );
                      return;
                    }
                    context.push(
                      '/checkout/payment',
                      extra: {
                        'scheduledDate': _selectedDate.toIso8601String(),
                        'timeSlot': _selectedSlot,
                        'specialInstructions': _instructionsController.text.trim(),
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
