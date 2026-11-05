import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/service_category.dart';
import '../../../data/models/service_item.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../auth/providers/auth_provider.dart';

final zovraRepositoryProvider = Provider<ZovraRepository>((ref) {
  final storage = ref.watch(localStorageProvider);
  return ZovraRepository(storage);
});

final bannersProvider = Provider<List<BannerModel>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return repo.getBanners();
});

final categoriesProvider = Provider<List<ServiceCategory>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return repo.getCategories();
});

final popularServicesProvider = Provider<List<ServiceItem>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return repo.getPopularServices();
});

final trendingServicesProvider = Provider<List<ServiceItem>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return repo.getTrendingServices();
});

final bestSellersProvider = Provider<List<ServiceItem>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return repo.getBestSellers();
});

final massageServicesProvider = Provider<List<ServiceItem>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  final all = repo.getServices();
  const signatureIds = [
    'srv_dry_massage',
    'srv_swedish_massage',
    'srv_deep_tissue',
    'srv_sports_massage',
    'srv_aromatherapy',
  ];
  final signature = all.where((s) => signatureIds.contains(s.id)).toList();
  return signature.isNotEmpty ? signature : all.take(5).toList();
});

final currentLocationProvider = StateProvider<String>((ref) {
  return '${AppConstants.defaultAddressSnippet}, ${AppConstants.defaultCity}';
});

