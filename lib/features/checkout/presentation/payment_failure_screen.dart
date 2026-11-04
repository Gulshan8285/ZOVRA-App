import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/zovra_button.dart';

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Failure Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.error, width: 1.5),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.error,
                  size: 48,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Payment Failed',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'We couldn\'t process your payment. If any amount was debited from your bank, it will be automatically refunded within 24–48 hours.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Reason: Simulated gateway rejection for sandbox verification.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              ZovraButton(
                text: 'Try Another Payment Method',
                height: 52,
                onPressed: () => context.pop(),
              ),

              const SizedBox(height: 12),

              ZovraButton(
                text: 'Need Help? Contact Support',
                variant: ZovraButtonVariant.outline,
                height: 50,
                onPressed: () => context.push('/support'),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

