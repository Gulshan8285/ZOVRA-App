import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/zovra_button.dart';
import '../../../home/providers/home_provider.dart';
import '../../providers/services_provider.dart';

class ServiceFilterSheet extends ConsumerStatefulWidget {
  const ServiceFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ServiceFilterSheet(),
    );
  }

  @override
  ConsumerState<ServiceFilterSheet> createState() => _ServiceFilterSheetState();
}

class _ServiceFilterSheetState extends ConsumerState<ServiceFilterSheet> {
  late String _selectedSort;
  String? _selectedCategory;
  double? _minRating;
  RangeValues _priceRange = const RangeValues(400, 5000);

  @override
  void initState() {
    super.initState();
    final current = ref.read(exploreFilterProvider);
    _selectedSort = current.sortBy;
    _selectedCategory = current.selectedCategoryId;
    _minRating = current.minRating;
    _priceRange = RangeValues(
      current.minPrice ?? 400,
      current.maxPrice ?? 5000,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter & Sort Services',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(exploreFilterProvider.notifier).resetFilters();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset All'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sort By
          Text(
            'SORT BY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortChip('Most Popular', 'popular'),
              _buildSortChip('Top Rated', 'rating'),
              _buildSortChip('Price: Low to High', 'price_asc'),
              _buildSortChip('Price: High to Low', 'price_desc'),
            ],
          ),

          const SizedBox(height: 20),

          // Rating Filter
          Text(
            'MINIMUM RATING',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRatingChip('Any Rating', null),
              const SizedBox(width: 8),
              _buildRatingChip('4.5★ & above', 4.5),
              const SizedBox(width: 8),
              _buildRatingChip('4.8★ & above', 4.8),
            ],
          ),

          const SizedBox(height: 20),

          // Category Filter
          Text(
            'CATEGORY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('All Categories', null),
                ...categories.map((c) => _buildCategoryChip(c.name, c.id)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Price Range Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PRICE RANGE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '₹${_priceRange.start.toInt()} - ₹${_priceRange.end.toInt()}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 300,
            max: 6000,
            divisions: 57,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
            onChanged: (values) => setState(() => _priceRange = values),
          ),

          const SizedBox(height: 20),

          // Apply Button
          ZovraButton(
            text: 'Apply Filters',
            height: 48,
            onPressed: () {
              final notifier = ref.read(exploreFilterProvider.notifier);
              notifier.setSortBy(_selectedSort);
              notifier.selectCategory(_selectedCategory);
              notifier.setMinRating(_minRating);
              notifier.setPriceRange(_priceRange.start, _priceRange.end);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _selectedSort == value;
    return ChoiceChip(
      label: Text(label),
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
        width: 1,
      ),
      onSelected: (_) => setState(() => _selectedSort = value),
    );
  }

  Widget _buildRatingChip(String label, double? value) {
    final isSelected = _minRating == value;
    return ChoiceChip(
      label: Text(label),
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
        width: 1,
      ),
      onSelected: (_) => setState(() => _minRating = value),
    );
  }

  Widget _buildCategoryChip(String label, String? catId) {
    final isSelected = _selectedCategory == catId;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
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
          width: 1,
        ),
        onSelected: (_) => setState(() => _selectedCategory = catId),
      ),
    );
  }
}
