import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locora_mobile/features/places/data/datasources/places_remote_datasource.dart';
import 'package:locora_mobile/features/places/data/repositories/places_repository_impl.dart';
import 'package:locora_mobile/features/places/domain/entities/place.dart';
import 'package:locora_mobile/features/places/domain/repositories/places_repository.dart';
import 'package:locora_mobile/features/places/domain/usecases/get_nearby_places.dart';

/// Phase 0 placeholder providers.
///
/// They exist only to validate Clean Architecture + Riverpod wiring.
/// Real user-facing places flows start in later phases.
final placesRemoteDataSourceProvider = Provider<PlacesRemoteDataSource>(
  (ref) => PlacesRemoteDataSourceImpl(),
);

final placesRepositoryProvider = Provider<PlacesRepository>(
  (ref) => PlacesRepositoryImpl(ref.watch(placesRemoteDataSourceProvider)),
);

final getNearbyPlacesUseCaseProvider = Provider<GetNearbyPlaces>(
  (ref) => GetNearbyPlaces(ref.watch(placesRepositoryProvider)),
);

final nearbyPlacesProvider = FutureProvider.family<List<Place>, NearbyPlacesQuery>(
  (ref, query) {
    return ref.watch(getNearbyPlacesUseCaseProvider).call(
          latitude: query.latitude,
          longitude: query.longitude,
          radiusMeters: query.radiusMeters,
        );
  },
);

class NearbyPlacesQuery {
  const NearbyPlacesQuery({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  final double latitude;
  final double longitude;
  final int radiusMeters;
}
