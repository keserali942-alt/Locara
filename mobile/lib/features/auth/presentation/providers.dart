import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locora_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:locora_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locora_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_out.dart';
import 'package:locora_mobile/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

final signInWithEmailUseCaseProvider = Provider<SignInWithEmail>(
  (ref) => SignInWithEmail(ref.watch(authRepositoryProvider)),
);

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmail>(
  (ref) => SignUpWithEmail(ref.watch(authRepositoryProvider)),
);

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogle>(
  (ref) => SignInWithGoogle(ref.watch(authRepositoryProvider)),
);

final signInWithAppleUseCaseProvider = Provider<SignInWithApple>(
  (ref) => SignInWithApple(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOut>(
  (ref) => SignOut(ref.watch(authRepositoryProvider)),
);

final authStateChangesProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final currentUserIdProvider = Provider<String?>(
  (ref) => ref.watch(authRepositoryProvider).currentUserId(),
);

final currentUserEmailProvider = Provider<String?>(
  (ref) => Supabase.instance.client.auth.currentUser?.email,
);

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(signInWithEmailUseCaseProvider).call(
            email: email,
            password: password,
          ),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(signUpWithEmailUseCaseProvider).call(
            email: email,
            password: password,
          ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(signInWithGoogleUseCaseProvider).call(),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(signInWithAppleUseCaseProvider).call(),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(signOutUseCaseProvider).call(),
    );
  }
}
