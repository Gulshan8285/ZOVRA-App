import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/whatsapp_share_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_grid.dart';
import 'widgets/featured_service_card.dart';
import 'widgets/home_header.dart';
import 'widgets/trust_metrics_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final massageServices = ref.watch(massageServicesProvider);
    final popularServices = ref.watch(popularServicesProvider);
    final trendingServices = ref.watch(trendingServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Location, Live Cart, Unread Bell & Profile
              const HomeHeader(),

              // 2026 Glass Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () => context.push('/explore'),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderGlass.withOpacity(0.35), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search "Dry Massage", "Deep Tissue", "Swedish"...',
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // WhatsApp Share Pill Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: InkWell(
                  onTap: () => WhatsAppShareService.shareApp(),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.whatsapp.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.whatsapp.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AppColors.whatsapp,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share_rounded, color: Colors.white, size: 12),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Share ZOVRA wellness with friends & family on WhatsApp',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.whatsapp),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Promotional Editorial Banners Carousel
              const BannerCarousel(),

              const SizedBox(height: 16),

              // FEATURED SECTION: Signature 1-Hr Therapies (Exact User Pricing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlassCard,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.borderGlass.withOpacity(0.4), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.spa_rounded, color: AppColors.primary, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SIGNATURE THERAPIES',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ALL 1 HR SESSIONS',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Full Body Massage Experiences',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Certified wellness partners arrive with portable massage table, sealed single-use linens & cold-pressed oils.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Horizontal Carousel for the User-Priced Massage Options
              SizedBox(
                height: 310,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: massageServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return FeaturedServiceCard(
                      service: massageServices[index],
                      isHorizontal: true,
                      width: 270,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 10 Massage Subcategories Grid
              const CategoryGrid(),

              const SizedBox(height: 20),

              // Trust & Ethical Care Quality Banner
              const TrustMetricsBanner(),

              const SizedBox(height: 24),

              // Popular Restorative Treatments
              _buildSectionHeader(
                context,
                title: 'Most Popular Massages',
                subtitle: 'Highly rated by 15,000+ satisfied clients across city',
                onSeeAll: () => context.push('/explore'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 310,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: popularServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return FeaturedServiceCard(
                      service: popularServices[index],
                      isHorizontal: true,
                      width: 270,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Couple & Luxury Spa Rituals (Full-Width List View)
              _buildSectionHeader(
                context,
                title: 'Luxury Spa Rituals & Couple Care',
                subtitle: 'Opulent multi-step rejuvenation in the comfort of home',
                onSeeAll: () => context.push('/explore'),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: trendingServices.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: FeaturedServiceCard(
                        service: service,
                        isHorizontal: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text(
                  'View All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
