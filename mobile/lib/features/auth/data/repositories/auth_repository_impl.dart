import 'package:locora_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:locora_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AuthState> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }

  @override
  String? currentUserId() {
    return _remoteDataSource.currentUserId();
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signUpWithEmail(email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signInWithApple() {
    return _remoteDataSource.signInWithApple();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}
