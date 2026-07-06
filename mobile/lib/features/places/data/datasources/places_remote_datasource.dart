import 'package:locora_mobile/config/supabase_config.dart';
import 'package:locora_mobile/features/places/data/models/place_model.dart';

/// Phase 0 placeholder contract.
///
/// This interface is intentionally minimal and will be replaced/expanded in Phase 2
/// when real place discovery behavior is introduced.
abstract class PlacesRemoteDataSource {
  Future<List<PlaceModel>> fetchNearbyPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  });
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  @override
  Future<List<PlaceModel>> fetchNearbyPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    // Phase 0 placeholder call path: keeps repository/usecase wiring testable
    // without introducing Phase 2 behavior in the mobile app.
    final response = await SupabaseConfig.client.functions.invoke(
      'place-provider',
      body: {
        'lat': latitude,
        'lng': longitude,
        'radius': radiusMeters,
      },
    );

    final data = response.data;
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(PlaceModel.fromJson)
        .toList();
  }
}
