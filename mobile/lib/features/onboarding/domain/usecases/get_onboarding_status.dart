import 'package:locora_mobile/features/onboarding/domain/repositories/discovery_profile_repository.dart';

class GetOnboardingStatus {
  const GetOnboardingStatus(this._repository);

  final DiscoveryProfileRepository _repository;

  Future<bool> call(String userId) {
    return _repository.hasCompletedOnboarding(userId);
  }
}
