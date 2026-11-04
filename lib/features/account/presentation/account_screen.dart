import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/whatsapp_share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../auth/providers/auth_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Account',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        child: Column(
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderGlass),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: user?.avatarUrl.isNotEmpty == true
                            ? NetworkImage(user!.avatarUrl)
                            : null,
                        child: user == null || user.avatarUrl.isEmpty
                            ? const Icon(Icons.person, size: 32, color: AppColors.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user?.name ?? 'Guest User',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (user?.isDemoUser == true) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'DEMO',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'demo@zovra.com',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (user?.phone.isNotEmpty == true) ...[
                          const SizedBox(height: 2),
                          Text(
                            user!.phone,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                    onPressed: () => context.push('/profile/edit'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // WhatsApp Share & Referral Card
            InkWell(
              onTap: () => WhatsAppShareService.shareApp(),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0x2825D366), Color(0x1500D2FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0x5525D366)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF25D366),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share ZOVRA on WhatsApp',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Invite friends & family to experience doorstep spa therapies.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF25D366), size: 14),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Section 1: Bookings & Activity
            _buildSectionHeader('BOOKINGS & ADDRESSES'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.calendar_today_rounded,
                title: 'My Bookings',
                subtitle: 'Active appointments and history',
                onTap: () => context.go('/bookings'),
              ),
              _buildMenuItem(
                icon: Icons.location_on_rounded,
                title: 'Saved Addresses',
                subtitle: 'Manage home, office and other locations',
                onTap: () => context.push('/addresses'),
              ),
              _buildMenuItem(
                icon: Icons.receipt_long_rounded,
                title: 'Payment History & Invoices',
                subtitle: 'View past charges, mode & transaction IDs',
                onTap: () => context.push('/account/payments'),
              ),
            ]),

            const SizedBox(height: 20),

            // Section 2: Perks & Alerts
            _buildSectionHeader('OFFERS & ALERTS'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.local_offer_rounded,
                title: 'Coupons & Discounts',
                subtitle: 'Browse unlocked vouchers and promotional codes',
                onTap: () => context.go('/offers'),
              ),
              _buildMenuItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Booking updates and promotional messages',
                onTap: () => context.push('/notifications'),
              ),
            ]),

            const SizedBox(height: 20),

            // Section 3: Help & Admin Tools
            _buildSectionHeader('SUPPORT & TESTING TOOLS'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.headset_mic_rounded,
                title: 'Help & Support',
                subtitle: 'FAQs, ticket creation, call & WhatsApp support',
                onTap: () => context.push('/support'),
              ),
              _buildMenuItem(
                icon: Icons.admin_panel_settings_rounded,
                title: 'Admin Controls & Live Testing',
                subtitle: 'Manage catalog, change booking status live, add coupons',
                highlight: true,
                onTap: () => context.push('/admin'),
              ),
            ]),

            const SizedBox(height: 20),

            // Section 4: Legal & App Info
            _buildSectionHeader('LEGAL & COMPLIANCE'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'About ZOVRA',
                onTap: () => context.push('/legal/about'),
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () => context.push('/legal/terms'),
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => context.push('/legal/privacy'),
              ),
            ]),

            const SizedBox(height: 24),

            // Logout & Account Deletion Actions
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.textPrimary),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () {
                      ConfirmationDialog.show(
                        context,
                        title: 'Log out of ZOVRA?',
                        message: 'You can sign back in anytime using your Google or demo account.',
                        confirmText: 'Log Out',
                        onConfirm: () async {
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            context.go('/welcome');
                          }
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                    title: Text(
                      'Delete Account',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently remove all profile data & bookings',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () {
                      ConfirmationDialog.show(
                        context,
                        title: 'Delete Account Permanently?',
                        message:
                            'This will immediately remove your personal profile, addresses, and saved bookings. This action cannot be undone.',
                        confirmText: 'Delete Forever',
                        isDestructive: true,
                        onConfirm: () async {
                          await ref.read(authProvider.notifier).deleteAccount();
                          if (context.mounted) {
                            context.go('/welcome');
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'ZOVRA Version 1.0.0 (Production Release)',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGlassCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGlass),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool highlight = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primaryLight : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: highlight ? AppColors.primary : AppColors.textPrimary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: highlight ? AppColors.primaryDark : AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
    );
  }
}

