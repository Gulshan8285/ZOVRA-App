import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/whatsapp_share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/widgets/rating_chip.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../../data/models/booking_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/bookings_provider.dart';
import 'widgets/cancel_booking_dialog.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  void _advanceBookingStatus(BuildContext context, WidgetRef ref, BookingModel booking) {
    BookingStatus nextStatus;
    switch (booking.status) {
      case BookingStatus.pending:
      case BookingStatus.confirmed:
        nextStatus = BookingStatus.partnerAssigned;
        break;
      case BookingStatus.partnerAssigned:
        nextStatus = BookingStatus.onTheWay;
        break;
      case BookingStatus.onTheWay:
        nextStatus = BookingStatus.inProgress;
        break;
      case BookingStatus.inProgress:
        nextStatus = BookingStatus.completed;
        break;
      case BookingStatus.completed:
      case BookingStatus.cancelled:
        return;
    }

    ref.read(bookingsProvider.notifier).updateBookingStatus(booking.id, nextStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to: ${nextStatus.label}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(bookingsProvider);
    final booking = bookingsState.bookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => bookingsState.bookings.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          'Booking #${booking.id}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Share on WhatsApp',
            icon: const Icon(Icons.share_rounded, color: AppColors.whatsapp),
            onPressed: () {
              final serviceName = booking.items.isNotEmpty
                  ? booking.items.first.service.name
                  : 'Massage Therapy';
              WhatsAppShareService.shareBookingConfirmation(
                bookingId: booking.id,
                serviceName: serviceName,
                dateTimeText:
                    '${DateTimeUtils.formatMediumDate(booking.scheduledDate)}, ${booking.timeSlot}',
              );
            },
          ),
          IconButton(
            tooltip: 'Return to Home',
            icon: const Icon(Icons.home_rounded, color: AppColors.primary, size: 24),
            onPressed: () => context.go('/'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: booking.status.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: booking.status.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: booking.status.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      booking.status == BookingStatus.completed
                          ? Icons.check_circle_rounded
                          : (booking.status == BookingStatus.cancelled
                              ? Icons.cancel_rounded
                              : Icons.schedule_rounded),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.status.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: booking.status.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          booking.status == BookingStatus.completed
                              ? 'Service completed successfully'
                              : (booking.status == BookingStatus.cancelled
                                  ? 'Cancelled · ${booking.cancellationReason ?? 'By customer'}'
                                  : 'Scheduled for ${DateTimeUtils.formatMediumDate(booking.scheduledDate)}, ${booking.timeSlot}'),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Demo Status Advance Shortcut Banner
            if (booking.status != BookingStatus.completed &&
                booking.status != BookingStatus.cancelled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Simulate next booking stage in demo:',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        backgroundColor: AppColors.primaryLight,
                      ),
                      onPressed: () => _advanceBookingStatus(context, ref, booking),
                      child: const Text('Next Step', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Live Tracking Timeline
            if (booking.status != BookingStatus.cancelled) ...[
              Text(
                'Live Service Status',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _buildTimeline(booking),
              const SizedBox(height: 24),
            ],

            // Assigned Partner Card
            if (booking.status != BookingStatus.cancelled) ...[
              Text(
                'Assigned Service Professional',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        booking.partnerAvatar,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.person, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                booking.partnerName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded,
                                  color: AppColors.primary, size: 16),
                            ],
                          ),
                          const SizedBox(height: 4),
                          RatingChip(
                            rating: booking.partnerRating,
                            reviewCount: 380,
                            compact: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Background Checked & Vaccinated',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.call_rounded,
                            color: AppColors.primary, size: 18),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling partner at ${booking.partnerPhone}...'),
                            backgroundColor: AppColors.dark,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Booked Services Summary
            Text(
              'Booked Services',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...booking.items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.service.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.service.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (item.selectedPackage != null)
                            Text(
                              item.selectedPackage!.title,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.primary,
                              ),
                            ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(item.totalPrice),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Service Location Card
            Text(
              'Service Address',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.address.tag,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.address.fullAddress,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bill & Payment Breakdown
            Text(
              'Payment Details',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildRow('Item Subtotal', CurrencyFormatter.format(booking.subtotal)),
                  if (booking.couponDiscount > 0)
                    _buildRow(
                      'Coupon Discount (${booking.couponCode ?? ''})',
                      '- ${CurrencyFormatter.format(booking.couponDiscount)}',
                      isGreen: true,
                    ),
                  _buildRow('GST & Taxes', CurrencyFormatter.format(booking.taxAmount)),
                  _buildRow('Visiting & Safety Charge', CurrencyFormatter.format(booking.platformFee)),
                  const Divider(height: 20),
                  _buildRow(
                    'Total Amount',
                    CurrencyFormatter.format(booking.totalAmount),
                    isBold: true,
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Mode',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Text(
                        booking.paymentMethod,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction ID',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Text(
                        booking.transactionId,
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Official Tax Invoice Action
            const SizedBox(height: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                side: const BorderSide(color: AppColors.primaryBorder),
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 19),
              label: Text(
                'View Official GST Tax Invoice',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () => _showInvoiceDialog(context, booking),
            ),

            const SizedBox(height: 16),

            // Cancel Button if eligible
            if (booking.canBeCancelled) ...[
              ZovraButton(
                text: 'Cancel Booking',
                variant: ZovraButtonVariant.danger,
                height: 48,
                onPressed: () {
                  CancelBookingDialog.show(
                    context,
                    onConfirmCancel: (reason) {
                      ref.read(bookingsProvider.notifier).cancelBooking(booking.id, reason);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking has been cancelled.'),
                          backgroundColor: AppColors.dark,
                        ),
                      );
                    },
                  );
                },
              ),
            ],

            if (booking.status == BookingStatus.completed && !booking.isReviewed) ...[
              const SizedBox(height: 12),
              ZovraButton(
                text: 'Rate & Review Service',
                icon: const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                height: 48,
                onPressed: () => context.push('/write-review/${booking.id}'),
              ),
            ],

            if (booking.status == BookingStatus.completed || booking.status == BookingStatus.cancelled) ...[
              const SizedBox(height: 12),
              ZovraButton(
                text: 'Rebook This Massage Therapy',
                icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 18),
                height: 48,
                onPressed: () {
                  if (booking.items.isNotEmpty) {
                    final item = booking.items.first;
                    ref.read(cartProvider.notifier).addToCart(
                          service: item.service,
                          package: item.selectedPackage,
                          addOns: item.selectedAddOns,
                        );
                    context.push('/cart');
                  } else {
                    context.push('/massage');
                  }
                },
              ),
            ],

            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                side: const BorderSide(color: AppColors.border),
                backgroundColor: AppColors.surfaceMuted,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.home_outlined, color: AppColors.textPrimary, size: 19),
              label: Text(
                'Return to Home',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isGreen = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isGreen
                    ? AppColors.success
                    : (isBold ? AppColors.textPrimary : AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BookingModel booking) {
    final steps = [
      {'title': 'Booking Confirmed', 'subtitle': 'Order placed successfully'},
      {'title': 'Partner Assigned', 'subtitle': '${booking.partnerName} accepted request'},
      {'title': 'Partner on the Way', 'subtitle': 'Travelling with sanitized equipment'},
      {'title': 'Service In Progress', 'subtitle': 'Therapy / cleaning started'},
      {'title': 'Service Completed', 'subtitle': 'Payment verified & closed'},
    ];

    final currentStep = booking.status.stepIndex;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final isPast = index < currentStep;
          final isCurrent = index == currentStep;
          final isLast = index == steps.length - 1;

          Color dotColor = AppColors.border;
          if (isPast) dotColor = AppColors.success;
          if (isCurrent) dotColor = AppColors.primary;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: isPast
                            ? const Icon(Icons.check, size: 12, color: Colors.white)
                            : (isCurrent
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isPast ? AppColors.success : AppColors.border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[index]['title']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                            color: isCurrent
                                ? AppColors.primary
                                : (isPast ? AppColors.textPrimary : AppColors.textMuted),
                          ),
                        ),
                        Text(
                          steps[index]['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showInvoiceDialog(BuildContext context, BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.88,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax Invoice Receipt',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Invoice Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ZOVRA',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Doorstep Luxury Wellness Services',
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              Text(
                                'GSTIN: 07AABCZ1234F1Z5',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.successBorder),
                            ),
                            child: Text(
                              'PAID',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Metadata
                      _buildRow('Invoice No.', 'INV-${booking.id}'),
                      _buildRow('Booking ID', '#${booking.id}'),
                      _buildRow('Date of Service', '${DateTimeUtils.formatMediumDate(booking.scheduledDate)}, ${booking.timeSlot}'),
                      _buildRow('SAC Code', '999721 (Wellness Therapies)'),
                      _buildRow('Customer Name', booking.address.tag),
                      _buildRow('Delivery Address', booking.address.shortAddress),

                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Line Items
                      Text(
                        'SERVICES RENDERED',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...booking.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${item.service.name} (${item.selectedPackage?.title ?? ''})',
                                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(item.totalPrice),
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Financial Breakdown
                      _buildRow('Subtotal', CurrencyFormatter.format(booking.subtotal)),
                      if (booking.couponDiscount > 0)
                        _buildRow('Coupon Discount (${booking.couponCode ?? ''})', '- ${CurrencyFormatter.format(booking.couponDiscount)}', isGreen: true),
                      _buildRow('CGST (9%)', CurrencyFormatter.format(booking.taxAmount / 2)),
                      _buildRow('SGST (9%)', CurrencyFormatter.format(booking.taxAmount / 2)),
                      _buildRow('Safety & Visiting Fee', CurrencyFormatter.format(booking.platformFee)),
                      const Divider(height: 18),
                      _buildRow('Grand Total', CurrencyFormatter.format(booking.totalAmount), isBold: true),
                      const Divider(height: 18),
                      _buildRow('Payment Mode', booking.paymentMethod),
                      _buildRow('Transaction Ref', booking.transactionId),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.download_rounded, size: 18, color: AppColors.textPrimary),
                      label: Text(
                        'Download PDF',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tax Invoice INV-${booking.id} downloaded successfully.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.home_rounded, size: 18, color: Colors.white),
                      label: Text(
                        'Done · Home',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.go('/');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
