import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:locora_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:locora_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  String? email;
  String? password;
  bool googleCalled = false;
  bool appleCalled = false;
  bool signOutCalled = false;
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> authStateChanges() => _controller.stream;

  @override
  String? currentUserId() => 'user-1';

  @override
  Future<void> signInWithApple() async {
    appleCalled = true;
  }

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    this.email = email;
    this.password = password;
  }

  @override
  Future<void> signInWithGoogle() async {
    googleCalled = true;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<void> signUpWithEmail({required String email, required String password}) async {
    this.email = email;
    this.password = password;
  }
}

void main() {
  test('auth repository forwards authentication calls', () async {
    final remote = FakeAuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remote);

    await repository.signInWithEmail(email: 'user@example.com', password: 'secret12');
    await repository.signUpWithEmail(email: 'user@example.com', password: 'secret12');
    await repository.signInWithGoogle();
    await repository.signInWithApple();
    await repository.signOut();

    expect(remote.email, 'user@example.com');
    expect(remote.password, 'secret12');
    expect(remote.googleCalled, isTrue);
    expect(remote.appleCalled, isTrue);
    expect(remote.signOutCalled, isTrue);
    expect(repository.currentUserId(), 'user-1');
  });
}
