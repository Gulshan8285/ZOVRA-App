import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/notification_item.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../home/providers/home_provider.dart';

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  final ZovraRepository _repository;

  NotificationsNotifier(this._repository)
      : super(_repository.getNotifications());

  int get unreadCount => state.where((n) => !n.isRead).length;

  Future<void> markAsRead(String id) async {
    await _repository.markNotificationAsRead(id);
    state = _repository.getNotifications();
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllNotificationsAsRead();
    state = _repository.getNotifications();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return NotificationsNotifier(repo);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationsProvider);
  return notifs.where((n) => !n.isRead).length;
});

