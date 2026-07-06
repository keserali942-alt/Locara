import 'package:locora_mobile/features/onboarding/data/datasources/discovery_profile_remote_data_source.dart';
import 'package:locora_mobile/features/onboarding/data/models/discovery_profile_model.dart';
import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';
import 'package:locora_mobile/features/onboarding/domain/repositories/discovery_profile_repository.dart';

class DiscoveryProfileRepositoryImpl implements DiscoveryProfileRepository {
  const DiscoveryProfileRepositoryImpl(this._remoteDataSource);

  final DiscoveryProfileRemoteDataSource _remoteDataSource;

  @override
  Future<bool> hasCompletedOnboarding(String userId) {
    return _remoteDataSource.hasCompletedOnboarding(userId);
  }

  @override
  Future<void> saveProfile({
    required String userId,
    required String email,
    required DiscoveryProfile profile,
  }) {
    final model = DiscoveryProfileModel(
      activities: profile.activities,
      budgetTier: profile.budgetTier,
      companions: profile.companions,
      priorities: profile.priorities,
      walkingPreference: profile.walkingPreference,
      tripPace: profile.tripPace,
    );

    return _remoteDataSource.saveProfile(
      userId: userId,
      email: email,
      profile: model,
    );
  }
}
