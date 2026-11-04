import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/coupon_model.dart';
import '../../home/providers/home_provider.dart';

final offersProvider = Provider<List<CouponModel>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return repo.getCoupons();
});
