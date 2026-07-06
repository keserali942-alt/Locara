import 'package:flutter_test/flutter_test.dart';
import 'package:locora_mobile/features/onboarding/data/datasources/discovery_profile_remote_data_source.dart';
import 'package:locora_mobile/features/onboarding/data/models/discovery_profile_model.dart';
import 'package:locora_mobile/features/onboarding/data/repositories/discovery_profile_repository_impl.dart';
import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';

class FakeDiscoveryProfileRemoteDataSource
    implements DiscoveryProfileRemoteDataSource {
  bool completed = false;
  String? savedUserId;
  String? savedEmail;
  DiscoveryProfileModel? savedProfile;

  @override
  Future<bool> hasCompletedOnboarding(String userId) async => completed;

  @override
  Future<void> saveProfile({
    required String userId,
    required String email,
    required DiscoveryProfileModel profile,
  }) async {
    savedUserId = userId;
    savedEmail = email;
    savedProfile = profile;
  }
}

void main() {
  test('discovery profile repository checks status and saves profile', () async {
    final remote = FakeDiscoveryProfileRemoteDataSource();
    final repository = DiscoveryProfileRepositoryImpl(remote);

    expect(await repository.hasCompletedOnboarding('user-1'), isFalse);

    await repository.saveProfile(
      userId: 'user-1',
      email: 'user@example.com',
      profile: const DiscoveryProfile(
        activities: ['food'],
        budgetTier: 'medium',
        companions: ['friends'],
        priorities: ['budget'],
        walkingPreference: 'moderate',
        tripPace: 'balanced',
      ),
    );

    expect(remote.savedUserId, 'user-1');
    expect(remote.savedEmail, 'user@example.com');
    expect(remote.savedProfile, isNotNull);
  });
}
