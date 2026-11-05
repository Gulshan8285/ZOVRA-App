import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/home_provider.dart';

class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({super.key});

  @override
  ConsumerState<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<BannerCarousel> {
  static const int _kLoopMultiplier = 1000;
  late final PageController _pageController;
  int _currentRealIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final banners = ref.read(bannersProvider);
    final initialPage = banners.isNotEmpty ? (banners.length * (_kLoopMultiplier ~/ 2)) : 0;
    _pageController = PageController(initialPage: initialPage);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final banners = ref.read(bannersProvider);
      if (banners.isEmpty) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannersProvider);

    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 205,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length * _kLoopMultiplier,
            onPageChanged: (idx) => setState(() => _currentRealIndex = idx % banners.length),
            itemBuilder: (context, index) {
              final banner = banners[index % banners.length];
              return GestureDetector(
                onTap: () {
                  if (banner.targetCategoryId != null) {
                    context.push('/category/${banner.targetCategoryId}');
                  } else {
                    context.push('/search');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border, width: 1),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Background Luxury Spa Image
                        Positioned.fill(
                          child: Image.network(
                            banner.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.editorialNavy),
                          ),
                        ),
                        // Dark Navy Editorial Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.editorialNavy.withOpacity(0.92),
                                  AppColors.editorialNavy.withOpacity(0.65),
                                  Colors.black.withOpacity(0.20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Subtle Electric Blue Ambient Light Spot
                        Positioned(
                          top: -30,
                          left: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.18),
                            ),
                          ),
                        ),
                        // Watermark / Brand Badge
                        Positioned(
                          top: 14,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              'ZOVRA.com',
                              style: GoogleFonts.inter(
                                color: Colors.white60,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.3),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      banner.badgeText,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textOnPrimary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  if (banner.discountTag != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceGlassCard,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.borderGlass),
                                      ),
                                      child: Text(
                                        banner.discountTag!,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.accentIcyBlue,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 230,
                                child: Text(
                                  banner.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    height: 1.22,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 220,
                                child: Text(
                                  banner.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Book Now CTA Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      banner.ctaText.isNotEmpty ? banner.ctaText : 'Book Now',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textOnPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.textOnPrimary,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentRealIndex == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentRealIndex == i ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
                boxShadow: _currentRealIndex == i ? AppColors.electricGlow : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
