import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/zovra_button.dart';

class CancelBookingDialog extends StatefulWidget {
  final Function(String reason) onConfirmCancel;

  const CancelBookingDialog({super.key, required this.onConfirmCancel});

  static Future<void> show(
    BuildContext context, {
    required Function(String reason) onConfirmCancel,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => CancelBookingDialog(onConfirmCancel: onConfirmCancel),
    );
  }

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  String _selectedReason = 'Change in schedule / timing';
  final List<String> _reasons = [
    'Change in schedule / timing',
    'Booked by mistake',
    'Found alternate service provider',
    'Need different service combination',
    'Personal emergency',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.errorLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cancel_outlined,
                      color: AppColors.error, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  'Cancel Booking',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Please select a reason for cancellation. As per ZOVRA policy, full refund will be processed within 24 hours.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            ..._reasons.map((r) {
              final isSelected = _selectedReason == r;
              return RadioListTile<String>(
                value: r,
                groupValue: _selectedReason,
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: Text(
                  r,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedReason = val);
                },
              );
            }),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                AppConstants.cancellationPolicy,
                style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ZovraButton(
                    text: 'Keep Booking',
                    variant: ZovraButtonVariant.outline,
                    height: 44,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ZovraButton(
                    text: 'Confirm Cancel',
                    variant: ZovraButtonVariant.danger,
                    height: 44,
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onConfirmCancel(_selectedReason);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

