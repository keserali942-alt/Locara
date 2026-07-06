import 'package:locora_mobile/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmail {
  const SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmail(email: email, password: password);
  }
}
