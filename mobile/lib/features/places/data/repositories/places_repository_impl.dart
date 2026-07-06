import 'package:locora_mobile/features/places/data/datasources/places_remote_datasource.dart';
import 'package:locora_mobile/features/places/domain/entities/place.dart';
import 'package:locora_mobile/features/places/domain/repositories/places_repository.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  const PlacesRepositoryImpl(this._remoteDataSource);

  final PlacesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Place>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) {
    return _remoteDataSource.fetchNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );
  }
}
