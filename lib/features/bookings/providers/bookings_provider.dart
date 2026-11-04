import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/cart_item.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../home/providers/home_provider.dart';

class BookingsState {
  final List<BookingModel> bookings;
  final bool isLoading;
  final String? error;

  const BookingsState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
  });

  List<BookingModel> get upcomingBookings => bookings
      .where((b) =>
          b.status == BookingStatus.pending ||
          b.status == BookingStatus.confirmed ||
          b.status == BookingStatus.partnerAssigned ||
          b.status == BookingStatus.onTheWay ||
          b.status == BookingStatus.inProgress)
      .toList();

  List<BookingModel> get completedBookings =>
      bookings.where((b) => b.status == BookingStatus.completed).toList();

  List<BookingModel> get cancelledBookings =>
      bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  BookingsState copyWith({
    List<BookingModel>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return BookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BookingsNotifier extends StateNotifier<BookingsState> {
  final ZovraRepository _repository;

  BookingsNotifier(this._repository)
      : super(BookingsState(bookings: _repository.getBookings()));

  void refresh() {
    state = state.copyWith(bookings: _repository.getBookings());
  }

  Future<BookingModel> createBooking({
    required String userId,
    required List<CartItem> items,
    required DateTime scheduledDate,
    required String timeSlot,
    required AddressModel address,
    required double subtotal,
    required double serviceDiscount,
    required double couponDiscount,
    String? couponCode,
    required double taxAmount,
    required double platformFee,
    required double totalAmount,
    required String paymentMethod,
    required String paymentStatus,
    required String transactionId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final booking = await _repository.createBooking(
        userId: userId,
        items: items,
        scheduledDate: scheduledDate,
        timeSlot: timeSlot,
        address: address,
        subtotal: subtotal,
        serviceDiscount: serviceDiscount,
        couponDiscount: couponDiscount,
        couponCode: couponCode,
        taxAmount: taxAmount,
        platformFee: platformFee,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        transactionId: transactionId,
      );

      state = state.copyWith(
        bookings: _repository.getBookings(),
        isLoading: false,
      );
      return booking;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    state = state.copyWith(isLoading: true);
    await _repository.cancelBooking(bookingId, reason);
    state = state.copyWith(
      bookings: _repository.getBookings(),
      isLoading: false,
    );
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    state = state.copyWith(isLoading: true);
    await _repository.updateBookingStatus(bookingId, newStatus);
    state = state.copyWith(
      bookings: _repository.getBookings(),
      isLoading: false,
    );
  }
}

final bookingsProvider = StateNotifierProvider<BookingsNotifier, BookingsState>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return BookingsNotifier(repo);
});

