import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('localStorageProvider must be initialized');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(localStorageProvider);
  return AuthRepository(storage);
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState(user: _repository.getCurrentUser()));

  Future<void> loginWithDemo() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.loginWithDemo();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loginWithGoogle({String? email, String? name, String? photoUrl}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.loginWithGoogle(
        email: email,
        name: name,
        photoUrl: photoUrl,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updated = await _repository.updateProfile(
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      state = state.copyWith(user: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(user: null);
  }

  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
    state = const AuthState(user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

