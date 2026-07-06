import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';

class DiscoveryProfileModel extends DiscoveryProfile {
  const DiscoveryProfileModel({
    required super.activities,
    required super.budgetTier,
    required super.companions,
    required super.priorities,
    required super.walkingPreference,
    required super.tripPace,
  });

  Map<String, dynamic> toJson(String userId) {
    return {
      'user_id': userId,
      'activities': activities,
      'budget_tier': budgetTier,
      'companions': companions,
      'priorities': priorities,
      'walking_preference': walkingPreference,
      'trip_pace': tripPace,
    };
  }
}
