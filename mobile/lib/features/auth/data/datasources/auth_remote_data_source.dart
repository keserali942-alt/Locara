import 'package:locora_mobile/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthState> authStateChanges();

  String? currentUserId();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Stream<AuthState> authStateChanges() {
    return SupabaseConfig.client.auth.onAuthStateChange;
  }

  @override
  String? currentUserId() {
    return SupabaseConfig.client.auth.currentUser?.id;
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await SupabaseConfig.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    await SupabaseConfig.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    await SupabaseConfig.client.auth.signInWithOAuth(OAuthProvider.google);
  }

  @override
  Future<void> signInWithApple() async {
    await SupabaseConfig.client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  @override
  Future<void> signOut() async {
    await SupabaseConfig.client.auth.signOut();
  }
}
