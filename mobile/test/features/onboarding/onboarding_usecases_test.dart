import 'package:flutter_test/flutter_test.dart';
import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';
import 'package:locora_mobile/features/onboarding/domain/repositories/discovery_profile_repository.dart';
import 'package:locora_mobile/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:locora_mobile/features/onboarding/domain/usecases/save_discovery_profile.dart';

class FakeDiscoveryProfileRepository implements DiscoveryProfileRepository {
  bool completed = false;
  DiscoveryProfile? savedProfile;
  String? savedUserId;
  String? savedEmail;

  @override
  Future<bool> hasCompletedOnboarding(String userId) async => completed;

  @override
  Future<void> saveProfile({
    required String userId,
    required String email,
    required DiscoveryProfile profile,
  }) async {
    savedUserId = userId;
    savedEmail = email;
    savedProfile = profile;
    completed = true;
  }
}

void main() {
  test('get onboarding status reads repository', () async {
    final repository = FakeDiscoveryProfileRepository()..completed = true;
    final useCase = GetOnboardingStatus(repository);

    expect(await useCase('user-1'), isTrue);
  });

  test('save discovery profile writes repository data', () async {
    final repository = FakeDiscoveryProfileRepository();
    final useCase = SaveDiscoveryProfile(repository);

    await useCase(
      userId: 'user-1',
      email: 'user@example.com',
      profile: const DiscoveryProfile(
        activities: ['food', 'culture'],
        budgetTier: 'medium',
        companions: ['friends'],
        priorities: ['budget'],
        walkingPreference: 'moderate',
        tripPace: 'balanced',
      ),
    );

    expect(repository.savedUserId, 'user-1');
    expect(repository.savedEmail, 'user@example.com');
    expect(repository.completed, isTrue);
  });
}
