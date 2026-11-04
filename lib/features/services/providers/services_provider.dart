import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/service_item.dart';
import '../../home/providers/home_provider.dart';

class ExploreFilterState {
  final String searchQuery;
  final String? selectedCategoryId;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String sortBy; // 'popular', 'price_asc', 'price_desc', 'rating'

  const ExploreFilterState({
    this.searchQuery = '',
    this.selectedCategoryId,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sortBy = 'popular',
  });

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      sortBy != 'popular';

  ExploreFilterState copyWith({
    String? searchQuery,
    String? selectedCategoryId,
    bool clearCategory = false,
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    double? minRating,
    bool clearMinRating = false,
    String? sortBy,
  }) {
    return ExploreFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class ExploreNotifier extends StateNotifier<ExploreFilterState> {
  ExploreNotifier() : super(const ExploreFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void selectCategory(String? categoryId) {
    if (state.selectedCategoryId == categoryId) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
  }

  void setPriceRange(double? min, double? max) {
    state = state.copyWith(
      minPrice: min,
      maxPrice: max,
      clearMinPrice: min == null,
      clearMaxPrice: max == null,
    );
  }

  void setMinRating(double? rating) {
    state = state.copyWith(
      minRating: rating,
      clearMinRating: rating == null,
    );
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void resetFilters() {
    state = ExploreFilterState(searchQuery: state.searchQuery);
  }
}

final exploreFilterProvider =
    StateNotifierProvider<ExploreNotifier, ExploreFilterState>((ref) {
  return ExploreNotifier();
});

final filteredServicesProvider = Provider<List<ServiceItem>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  final filter = ref.watch(exploreFilterProvider);

  return repo.searchServices(
    query: filter.searchQuery,
    categoryId: filter.selectedCategoryId,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
    minRating: filter.minRating,
    sortBy: filter.sortBy,
  );
});

final popularSearchTagsProvider = Provider<List<String>>((ref) {
  return [
    'Hydra Facial',
    'Deep Tissue',
    'Full Home Deep Cleaning',
    'Split AC Jet Service',
    'Manicure & Pedicure',
    'Rica Waxing',
    'Body Polishing',
  ];
});
