import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../providers/reviews_provider.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const WriteReviewScreen({super.key, required this.bookingId});

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  final Set<String> _selectedTags = {'Punctual', 'Hygienic Setup'};
  bool _isSubmitting = false;

  final List<String> _tagOptions = [
    'Punctual',
    'Hygienic Setup',
    'Professional Technique',
    'Gentle & Caring',
    'Spotless Clean',
    'Great Communication',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a brief feedback.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final bookingsState = ref.read(bookingsProvider);
    final booking = bookingsState.bookings.firstWhere(
      (b) => b.id == widget.bookingId,
      orElse: () => bookingsState.bookings.first,
    );
    final user = ref.read(authProvider).user;
    final firstItem = booking.items.first;

    await ref.read(reviewsProvider.notifier).submitReview(
          bookingId: booking.id,
          serviceId: firstItem.service.id,
          serviceName: firstItem.service.name,
          userId: user?.id ?? 'usr_guest',
          userName: user?.name ?? 'Gulshan Yadav',
          rating: _rating,
          comment: _commentController.text.trim(),
          tags: _selectedTags.toList(),
        );

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your verified review has been published.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsState = ref.watch(bookingsProvider);
    final booking = bookingsState.bookings.where((b) => b.id == widget.bookingId).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Rate & Review',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (booking != null && booking.items.isNotEmpty) ...[
              Text(
                'How was your experience with',
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                booking.items.first.service.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Service by ${booking.partnerName}',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.primary),
              ),
            ],

            const SizedBox(height: 24),

            // Star Rating Picker
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: AppColors.ratingGold,
              ),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),

            const SizedBox(height: 8),

            Text(
              _rating == 5.0
                  ? 'Excellent!'
                  : (_rating >= 4.0
                      ? 'Very Good!'
                      : (_rating >= 3.0 ? 'Average' : 'Could be better')),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 28),

            // Tags
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What did you like the most?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tagOptions.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  backgroundColor: AppColors.surfaceMuted,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Feedback Text Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Write your review',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Share your experience with the partner, hygiene, and results...',
              ),
            ),

            const SizedBox(height: 32),

            ZovraButton(
              text: 'Submit Verified Review',
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

