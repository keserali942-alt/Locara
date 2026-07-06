import 'package:locora_mobile/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.signInWithGoogle();
  }
}
