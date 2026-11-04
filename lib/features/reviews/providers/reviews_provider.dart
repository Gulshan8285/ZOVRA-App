import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../../home/providers/home_provider.dart';

class ReviewsNotifier extends StateNotifier<List<ReviewModel>> {
  final ZovraRepository _repository;
  final Ref _ref;

  ReviewsNotifier(this._repository, this._ref)
      : super(_repository.getReviews());

  void refresh() {
    state = _repository.getReviews();
  }

  Future<void> submitReview({
    required String bookingId,
    required String serviceId,
    required String serviceName,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
    List<String> tags = const [],
  }) async {
    await _repository.addReview(
      bookingId: bookingId,
      serviceId: serviceId,
      serviceName: serviceName,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      tags: tags,
    );
    state = _repository.getReviews();
    _ref.read(bookingsProvider.notifier).refresh();
  }
}

final reviewsProvider =
    StateNotifierProvider<ReviewsNotifier, List<ReviewModel>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return ReviewsNotifier(repo, ref);
});

final serviceReviewsProvider =
    Provider.family<List<ReviewModel>, String>((ref, serviceId) {
  final allReviews = ref.watch(reviewsProvider);
  return allReviews.where((r) => r.serviceId == serviceId).toList();
});

