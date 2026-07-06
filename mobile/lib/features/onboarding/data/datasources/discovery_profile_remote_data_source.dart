import 'package:locora_mobile/config/supabase_config.dart';
import 'package:locora_mobile/features/onboarding/data/models/discovery_profile_model.dart';

abstract class DiscoveryProfileRemoteDataSource {
  Future<bool> hasCompletedOnboarding(String userId);

  Future<void> saveProfile({
    required String userId,
    required String email,
    required DiscoveryProfileModel profile,
  });
}

class DiscoveryProfileRemoteDataSourceImpl
    implements DiscoveryProfileRemoteDataSource {
  @override
  Future<bool> hasCompletedOnboarding(String userId) async {
    final response = await SupabaseConfig.client
        .from('discovery_profile')
        .select('user_id')
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<void> saveProfile({
    required String userId,
    required String email,
    required DiscoveryProfileModel profile,
  }) async {
    await SupabaseConfig.client.from('users').upsert({
      'id': userId,
      'email': email,
    });

    await SupabaseConfig.client
        .from('discovery_profile')
        .upsert(profile.toJson(userId), onConflict: 'user_id');
  }
}
