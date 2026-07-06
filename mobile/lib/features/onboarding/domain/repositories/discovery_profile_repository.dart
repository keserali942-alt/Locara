import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';

abstract class DiscoveryProfileRepository {
  Future<bool> hasCompletedOnboarding(String userId);

  Future<void> saveProfile({
    required String userId,
    required String email,
    required DiscoveryProfile profile,
  });
}
