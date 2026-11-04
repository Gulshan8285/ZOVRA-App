import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/cart_item.dart';
import '../../../data/models/coupon_model.dart';
import '../../../data/models/service_item.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../home/providers/home_provider.dart';

class CartState {
  final List<CartItem> items;
  final CouponModel? appliedCoupon;
  final String? couponError;
  final bool isLoading;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.couponError,
    this.isLoading = false,
  });

  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  // Subtotal is based on discounted price
  double get subtotal => items.fold(0.0, (sum, i) => sum + i.totalPrice);

  // Original total before all discounts
  double get originalTotal => items.fold(0.0, (sum, i) => sum + i.totalOriginalPrice);

  // Direct service level savings
  double get serviceDiscount => originalTotal - subtotal;

  // Coupon discount
  double get couponDiscount {
    if (appliedCoupon == null) return 0.0;
    return appliedCoupon!.calculateDiscount(subtotal);
  }

  // Net amount after coupon
  double get netAmount => (subtotal - couponDiscount).clamp(0.0, double.infinity);

  // GST / Taxes
  double get taxAmount => (netAmount * (AppConstants.taxPercentage / 100.0));

  // Platform visiting fee
  double get platformFee => isEmpty ? 0.0 : AppConstants.platformFee;

  // Final payable total
  double get finalTotal => isEmpty ? 0.0 : (netAmount + taxAmount + platformFee);

  // Total savings customer makes
  double get totalCustomerSavings => serviceDiscount + couponDiscount;

  CartState copyWith({
    List<CartItem>? items,
    CouponModel? appliedCoupon,
    bool clearCoupon = false,
    String? couponError,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      couponError: couponError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final ZovraRepository _repository;

  CartNotifier(this._repository) : super(CartState(items: _repository.getCart()));

  Future<void> addToCart({
    required ServiceItem service,
    ServicePackage? package,
    List<ServiceAddOn> addOns = const [],
    int quantity = 1,
  }) async {
    final updated = await _repository.addToCart(
      service: service,
      package: package,
      addOns: addOns,
      quantity: quantity,
    );
    state = state.copyWith(items: updated);
    _revalidateCoupon();
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final updated = await _repository.updateCartItemQuantity(cartItemId, newQuantity);
    state = state.copyWith(items: updated);
    _revalidateCoupon();
  }

  Future<void> removeItem(String cartItemId) async {
    final updated = await _repository.removeFromCart(cartItemId);
    state = state.copyWith(items: updated);
    _revalidateCoupon();
  }

  Future<void> clearCart() async {
    await _repository.clearCart();
    state = const CartState(items: []);
  }

  bool applyCoupon(String code) {
    final coupon = _repository.findCoupon(code);
    if (coupon == null) {
      state = state.copyWith(couponError: 'Invalid coupon code "$code".');
      return false;
    }

    if (state.subtotal < coupon.minOrderAmount) {
      state = state.copyWith(
        couponError:
            'Minimum cart value of ₹${coupon.minOrderAmount.toInt()} required for this coupon.',
      );
      return false;
    }

    state = state.copyWith(appliedCoupon: coupon, couponError: null);
    return true;
  }

  void removeCoupon() {
    state = state.copyWith(clearCoupon: true, couponError: null);
  }

  void _revalidateCoupon() {
    if (state.appliedCoupon != null) {
      if (state.subtotal < state.appliedCoupon!.minOrderAmount) {
        state = state.copyWith(
          clearCoupon: true,
          couponError:
              'Coupon removed: minimum order ₹${state.appliedCoupon!.minOrderAmount.toInt()} not met.',
        );
      }
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return CartNotifier(repo);
});

