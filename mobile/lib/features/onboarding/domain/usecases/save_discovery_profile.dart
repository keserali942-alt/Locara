import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';
import 'package:locora_mobile/features/onboarding/domain/repositories/discovery_profile_repository.dart';

class SaveDiscoveryProfile {
  const SaveDiscoveryProfile(this._repository);

  final DiscoveryProfileRepository _repository;

  Future<void> call({
    required String userId,
    required String email,
    required DiscoveryProfile profile,
  }) {
    return _repository.saveProfile(
      userId: userId,
      email: email,
      profile: profile,
    );
  }
}
