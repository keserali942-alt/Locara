import 'package:flutter_test/flutter_test.dart';
import 'package:locora_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_out.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthRepository implements AuthRepository {
  String? email;
  String? password;
  bool googleCalled = false;
  bool appleCalled = false;
  bool signOutCalled = false;

  @override
  Stream<AuthState> authStateChanges() => const Stream.empty();

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
  test('email sign in usecase delegates to repository', () async {
    final repository = FakeAuthRepository();
    final useCase = SignInWithEmail(repository);

    await useCase(email: 'user@example.com', password: 'secret12');

    expect(repository.email, 'user@example.com');
    expect(repository.password, 'secret12');
  });

  test('email sign up usecase delegates to repository', () async {
    final repository = FakeAuthRepository();
    final useCase = SignUpWithEmail(repository);

    await useCase(email: 'user@example.com', password: 'secret12');

    expect(repository.email, 'user@example.com');
    expect(repository.password, 'secret12');
  });

  test('oauth and sign out usecases delegate to repository', () async {
    final repository = FakeAuthRepository();

    await SignInWithGoogle(repository).call();
    await SignInWithApple(repository).call();
    await SignOut(repository).call();

    expect(repository.googleCalled, isTrue);
    expect(repository.appleCalled, isTrue);
    expect(repository.signOutCalled, isTrue);
  });
}
