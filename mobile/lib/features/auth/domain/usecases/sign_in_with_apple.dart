import 'package:locora_mobile/features/auth/domain/repositories/auth_repository.dart';

class SignInWithApple {
  const SignInWithApple(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.signInWithApple();
  }
}
