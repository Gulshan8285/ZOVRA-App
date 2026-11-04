import 'package:uuid/uuid.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final LocalStorageService _storage;
  final _uuid = const Uuid();

  AuthRepository(this._storage);

  UserModel? getCurrentUser() {
    return _storage.getUser();
  }

  bool get isAuthenticated => getCurrentUser() != null;

  Future<UserModel> loginWithDemo() async {
    final demoUser = UserModel.demo();
    await _storage.saveUser(demoUser);
    return demoUser;
  }

  Future<UserModel> loginWithGoogle({
    String? email,
    String? name,
    String? photoUrl,
  }) async {
    // In production, this receives the GoogleSignInAccount from google_sign_in package
    // and Firebase UserCredential from FirebaseAuth.instance.signInWithCredential()
    final user = UserModel(
      id: 'usr_g_${_uuid.v4().substring(0, 8)}',
      name: name ?? 'Gulshan Yadav',
      email: email ?? 'gulshanyadav@gmail.com',
      phone: '+91 98765 43210',
      avatarUrl: photoUrl ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      isDemoUser: false,
      createdAt: DateTime.now(),
      defaultAddressId: 'addr_demo_1',
    );
    await _storage.saveUser(user);
    return user;
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  }) async {
    final current = getCurrentUser();
    if (current == null) {
      throw Exception('No active session found.');
    }

    final updated = current.copyWith(
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl ?? current.avatarUrl,
    );
    await _storage.saveUser(updated);
    return updated;
  }

  Future<void> logout() async {
    await _storage.clearUser();
  }

  Future<void> deleteAccount() async {
    await _storage.clearUser();
    await _storage.clearCart();
  }
}

