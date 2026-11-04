import 'package:flutter_test/flutter_test.dart';
import 'package:zovra/data/models/address_model.dart';
import 'package:zovra/data/models/booking_model.dart';
import 'package:zovra/data/models/cart_item.dart';
import 'package:zovra/data/models/coupon_model.dart';
import 'package:zovra/data/seeds/initial_data.dart';

void main() {
  group('ZOVRA Core Unit Tests', () {
    test('Initial services catalogue contains required categories', () {
      final categories = InitialData.getCategories();
      expect(categories.length, equals(10));

      final categoryNames = categories.map((c) => c.name).toList();
      expect(categoryNames, contains('Full Body Massage'));
      expect(categoryNames, contains('Swedish Massage'));
      expect(categoryNames, contains('Deep Tissue Massage'));
      expect(categoryNames, contains('Aromatherapy Massage'));
      expect(categoryNames, contains('Relaxation Massage'));
      expect(categoryNames, contains('Head & Shoulder Massage'));
      expect(categoryNames, contains('Back & Neck Massage'));
      expect(categoryNames, contains('Foot Reflexology'));
      expect(categoryNames, contains('Couple Massage'));
      expect(categoryNames, contains('Premium Spa Experience'));
    });

    test('Exact 1-Hr Massage Pricing corresponds to user requirements', () {
      final services = InitialData.getServices();

      final dry = services.firstWhere((s) => s.id == 'srv_dry_massage');
      expect(dry.discountedPrice, equals(849.0));
      expect(dry.durationMinutes, equals(60));

      final deepTissue = services.firstWhere((s) => s.id == 'srv_deep_tissue');
      expect(deepTissue.discountedPrice, equals(1549.0));
      expect(deepTissue.durationMinutes, equals(60));

      final aroma = services.firstWhere((s) => s.id == 'srv_aromatherapy');
      expect(aroma.discountedPrice, equals(2049.0));
      expect(aroma.durationMinutes, equals(60));

      final swedish = services.firstWhere((s) => s.id == 'srv_swedish_massage');
      expect(swedish.discountedPrice, equals(1249.0));
      expect(swedish.durationMinutes, equals(60));

      final sports = services.firstWhere((s) => s.id == 'srv_sports_massage');
      expect(sports.discountedPrice, equals(1749.0));
      expect(sports.durationMinutes, equals(60));
    });

    test('Coupon calculation accurately computes discounts', () {
      final couponPercentage = CouponModel(
        id: 'c1',
        code: 'WELCOME10',
        title: '10% Welcome',
        description: '10% off',
        discountType: 'percentage',
        discountValue: 10.0,
        minOrderAmount: 500.0,
        maxDiscount: 200.0,
        validTill: DateTime.now().add(const Duration(days: 30)),
      );

      // Below min order
      expect(couponPercentage.calculateDiscount(400.0), equals(0.0));
      // Normal percentage
      expect(couponPercentage.calculateDiscount(1000.0), equals(100.0));
      // Max discount cap
      expect(couponPercentage.calculateDiscount(3000.0), equals(200.0));

      final couponFlat = CouponModel(
        id: 'c2',
        code: 'FIRSTBOOKING',
        title: 'Flat 300',
        description: 'Flat 300 off',
        discountType: 'flat',
        discountValue: 300.0,
        minOrderAmount: 1000.0,
        maxDiscount: 300.0,
        validTill: DateTime.now().add(const Duration(days: 30)),
      );

      expect(couponFlat.calculateDiscount(900.0), equals(0.0));
      expect(couponFlat.calculateDiscount(1500.0), equals(300.0));
    });

    test('CartItem price and total savings calculations', () {
      final service = InitialData.getServices().first; // Dry massage
      final cartItem = CartItem(
        id: 'test_item_1',
        service: service,
        quantity: 2,
        selectedPackage: service.packages[1], // 60-min signature package (849 vs 1199)
      );

      expect(cartItem.unitPrice, equals(849.0));
      expect(cartItem.totalPrice, equals(1698.0));
      expect(cartItem.totalOriginalPrice, equals(2398.0));
      expect(cartItem.totalSavings, equals(700.0));
    });

    test('AddressModel formats full and short addresses properly', () {
      const address = AddressModel(
        id: 'addr_test',
        tag: 'Home',
        houseNumber: 'Flat 101',
        buildingName: 'Palm Heights',
        streetLocality: 'Sector 43',
        city: 'Gurugram',
        state: 'Haryana',
        pincode: '122002',
        isDefault: true,
      );

      expect(address.shortAddress, equals('Flat 101, Palm Heights, Sector 43'));
      expect(
        address.fullAddress,
        equals('Flat 101, Palm Heights, Sector 43, Gurugram, Haryana, 122002'),
      );
    });

    test('BookingStatus extensions return correct step indices and labels', () {
      expect(BookingStatus.confirmed.stepIndex, equals(1));
      expect(BookingStatus.partnerAssigned.stepIndex, equals(2));
      expect(BookingStatus.onTheWay.stepIndex, equals(3));
      expect(BookingStatus.inProgress.stepIndex, equals(4));
      expect(BookingStatus.completed.stepIndex, equals(5));
      expect(BookingStatus.cancelled.stepIndex, equals(-1));
    });
  });
}
