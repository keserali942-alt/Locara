import 'package:locora_mobile/features/places/domain/entities/place.dart';
import 'package:locora_mobile/features/places/domain/repositories/places_repository.dart';

class GetNearbyPlaces {
  const GetNearbyPlaces(this._repository);

  final PlacesRepository _repository;

  Future<List<Place>> call({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) {
    return _repository.getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );
  }
}
