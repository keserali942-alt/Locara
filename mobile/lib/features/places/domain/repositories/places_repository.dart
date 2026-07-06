import 'package:locora_mobile/features/places/domain/entities/place.dart';

abstract class PlacesRepository {
  Future<List<Place>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  });
}
