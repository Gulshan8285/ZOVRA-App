import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/support_ticket.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../home/providers/home_provider.dart';

class SupportNotifier extends StateNotifier<List<SupportTicket>> {
  final ZovraRepository _repository;

  SupportNotifier(this._repository)
      : super(_repository.getSupportTickets());

  Future<SupportTicket> createTicket({
    required String userId,
    required String category,
    required String subject,
    required String message,
    String? bookingId,
  }) async {
    final ticket = await _repository.createSupportTicket(
      userId: userId,
      category: category,
      subject: subject,
      message: message,
      bookingId: bookingId,
    );
    state = _repository.getSupportTickets();
    return ticket;
  }
}

final supportProvider =
    StateNotifierProvider<SupportNotifier, List<SupportTicket>>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return SupportNotifier(repo);
});

