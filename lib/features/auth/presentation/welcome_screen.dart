import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/zovra_button.dart';
import '../providers/auth_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _activePage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> _onboardingSlides = [
    {
      'title': 'Luxury Home Care,\nAt Your Doorstep',
      'subtitle':
          'Certified therapists, beauticians & deep cleaning specialists at your fingertips.',
      'image':
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
      'tag': 'PREMIUM EXPERIENCE',
    },
    {
      'title': 'Dermatologist-Grade\nFacials & Salon',
      'subtitle':
          'Sterilized, single-use sealed kits with 100% genuine luxury products.',
      'image':
          'https://images.unsplash.com/photo-1512290900672-1f55b9a8cb40?auto=format&fit=crop&w=800&q=80',
      'tag': 'HYGIENE GUARANTEE',
    },
    {
      'title': 'Transparent Pricing,\nZero Hidden Charges',
      'subtitle':
          'Fixed upfront rates, verified background-checked partners, and 100% satisfaction guarantee.',
      'image':
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=800&q=80',
      'tag': 'TRUST & SAFETY',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleDemoLogin() async {
    await ref.read(authProvider.notifier).loginWithDemo();
    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _handleGoogleLogin() async {
    await ref.read(authProvider.notifier).loginWithGoogle();
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with ZOVRA Logo and Skip / Demo pill
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ZOVRA',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: AppColors.dark,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'v1.0 Ready',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Onboarding Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingSlides.length,
                onPageChanged: (idx) => setState(() => _activePage = idx),
                itemBuilder: (context, index) {
                  final slide = _onboardingSlides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            children: [
                              Image.network(
                                slide['image']!,
                                height: 260,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 260,
                                  color: AppColors.surfaceMuted,
                                  child: const Icon(Icons.image, size: 60, color: AppColors.textMuted),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slide['tag']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          slide['title']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingSlides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _activePage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _activePage == i ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Authentication Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.border, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: authState.isLoading ? null : _handleGoogleLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                            width: 20,
                            height: 20,
                            errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Demo Account Login Button
                  ZovraButton(
                    text: 'Explore in Demo Mode',
                    isLoading: authState.isLoading,
                    icon: const Icon(Icons.play_circle_outline_rounded, color: Colors.white, size: 20),
                    onPressed: _handleDemoLogin,
                    height: 52,
                  ),

                  const SizedBox(height: 16),

                  // Legal notice
                  Text(
                    'By continuing, you agree to ZOVRA\'s Terms of Service & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

