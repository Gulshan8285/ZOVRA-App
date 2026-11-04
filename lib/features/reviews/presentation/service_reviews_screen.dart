import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/rating_chip.dart';
import '../../home/providers/home_provider.dart';
import '../providers/reviews_provider.dart';

class ServiceReviewsScreen extends ConsumerWidget {
  final String serviceId;

  const ServiceReviewsScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(zovraRepositoryProvider);
    final service = repo.getServiceById(serviceId);
    final reviews = ref.watch(serviceReviewsProvider(serviceId));

    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reviews')),
        body: const Center(child: Text('Service not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Customer Reviews',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Breakdown Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      RatingBarIndicator(
                        rating: service.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.ratingGold,
                        ),
                        itemCount: 5,
                        itemSize: 18.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${service.reviewCount} verified ratings',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar('5★', 0.82),
                        _buildRatingBar('4★', 0.12),
                        _buildRatingBar('3★', 0.04),
                        _buildRatingBar('2★', 0.01),
                        _buildRatingBar('1★', 0.01),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'All Reviews (${reviews.length})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            if (reviews.isEmpty)
              const EmptyView(
                icon: Icons.rate_review_outlined,
                title: 'No Reviews Yet',
                subtitle: 'Be the first to book and share your feedback!',
              )
            else
              ...reviews.map((rev) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryLight,
                            backgroundImage: rev.userAvatar.isNotEmpty
                                ? NetworkImage(rev.userAvatar)
                                : null,
                            child: rev.userAvatar.isEmpty
                                ? Text(
                                    rev.userName[0],
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rev.userName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  DateTimeUtils.timeAgo(rev.createdAt),
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RatingChip(rating: rev.rating, compact: true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        rev.comment,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      if (rev.tags.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: rev.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#$tag',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.thumb_up_alt_outlined,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            'Helpful (${rev.helpfulCount})',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Spacer(),
                          if (rev.isVerifiedBooking)
                            Row(
                              children: [
                                const Icon(Icons.verified_rounded,
                                    size: 14, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified Booking',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(String star, double fraction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              star,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.surfaceMuted,
                color: AppColors.ratingGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

