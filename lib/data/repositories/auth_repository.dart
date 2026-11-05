import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final LocalStorageService _storage;
  final _uuid = const Uuid();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

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

  /// Real Google Sign-In Integration via official GoogleSignIn SDK
  Future<UserModel?> loginWithGoogle() async {
    try {
      // Initiates the Google native account selection sheet
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        // User voluntarily dismissed or cancelled the Google sheet
        return null;
      }

      final String googleId = account.id.length >= 8 ? account.id.substring(0, 8) : account.id;
      final user = UserModel(
        id: 'usr_g_$googleId',
        name: account.displayName != null && account.displayName!.trim().isNotEmpty
            ? account.displayName!
            : 'Google User',
        email: account.email,
        phone: '+91 98765 43210',
        avatarUrl: account.photoUrl ??
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
        isDemoUser: false,
        createdAt: DateTime.now(),
        defaultAddressId: 'addr_demo_1',
      );
      await _storage.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Developer fallback in case Google Cloud OAuth client / SHA-1 is not yet registered in GCP console
  Future<UserModel> loginWithGoogleFallback({
    String? email,
    String? name,
    String? photoUrl,
  }) async {
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
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
    await _storage.clearUser();
  }

  Future<void> deleteAccount() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
    } catch (_) {}
    await _storage.clearUser();
    await _storage.clearCart();
  }
}
