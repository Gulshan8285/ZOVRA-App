import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/support_provider.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How do I cancel or reschedule my booking?',
      'answer':
          'You can cancel or reschedule any upcoming booking free of charge up to 4 hours before the appointment slot by opening your booking and selecting "Cancel Booking" or contacting our support team.',
    },
    {
      'question': 'Are ZOVRA service professionals verified and safe?',
      'answer':
          'Yes, 100% of ZOVRA service partners undergo rigorous criminal background verification, in-person skill assessment, and follow sterile hygiene protocols using single-use sealed kits.',
    },
    {
      'question': 'How does the satisfaction guarantee & refund work?',
      'answer':
          'If you are dissatisfied with your service, let us know within 24 hours. We will either send a senior professional for a free re-work or issue a full refund to your original payment method.',
    },
    {
      'question': 'What if the service partner arrives late?',
      'answer':
          'If a partner is delayed beyond 15 minutes of your chosen slot window without prior notification, you are eligible for an instant ₹100 Zovra wallet compensation credit.',
    },
    {
      'question': 'Can I pay after the service is completed?',
      'answer':
          'Yes, we support Cash on Delivery (COD) as well as post-service UPI QR scanning upon completion.',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(supportProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Support Channels Grid
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need Instant Help?',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Our dedicated care team is available 7 days a week from 8:00 AM to 10:00 PM.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildQuickAction(
                        icon: Icons.call_rounded,
                        label: 'Call Us',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dialling ${AppConstants.supportPhone}...'),
                              backgroundColor: AppColors.dark,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildQuickAction(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'WhatsApp',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening WhatsApp Support chat...'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildQuickAction(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Composing email to ${AppConstants.supportEmail}...'),
                              backgroundColor: AppColors.info,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Support Tickets Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Support Tickets (${tickets.length})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          tickets.isEmpty
                              ? 'No complaints or issues reported'
                              : '${tickets.where((t) => t.status != 'Resolved').length} active tickets pending',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/support/tickets'),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Submit a Ticket CTA
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.add_comment_rounded, color: AppColors.primary, size: 18),
              label: Text(
                'Raise a Complaint or Request',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () => context.push('/support/create'),
            ),

            const SizedBox(height: 24),

            // Frequently Asked Questions
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ..._faqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Text(
                          faq['answer']!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

