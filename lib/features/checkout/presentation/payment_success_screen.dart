import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../bookings/providers/bookings_provider.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  final String bookingId;

  const PaymentSuccessScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(bookingsProvider);
    final booking = bookingsState.bookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => bookingsState.bookings.first,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Success Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.successBorder, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Booking Confirmed!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your service partner has been assigned and will arrive at your scheduled time.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Booking ID',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Text(
                          '#${booking.id}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Scheduled Time',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Text(
                          '${DateTimeUtils.formatMediumDate(booking.scheduledDate)}, ${booking.timeSlot.split('-').first.trim()}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount Paid',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Text(
                          CurrencyFormatter.format(booking.totalAmount),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment ID',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Text(
                          booking.transactionId,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              ZovraButton(
                text: 'Track Booking Status',
                icon: const Icon(Icons.timeline_rounded, color: Colors.white, size: 18),
                height: 52,
                onPressed: () => context.go('/booking/${booking.id}'),
              ),

              const SizedBox(height: 12),

              ZovraButton(
                text: 'Back to Home',
                variant: ZovraButtonVariant.outline,
                height: 50,
                onPressed: () => context.go('/'),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

