import 'package:flutter_test/flutter_test.dart';
import 'package:locora_mobile/features/places/data/datasources/places_remote_datasource.dart';
import 'package:locora_mobile/features/places/data/models/place_model.dart';
import 'package:locora_mobile/features/places/data/repositories/places_repository_impl.dart';
import 'package:locora_mobile/features/places/domain/entities/place.dart';
import 'package:locora_mobile/features/places/domain/repositories/places_repository.dart';
import 'package:locora_mobile/features/places/domain/usecases/get_nearby_places.dart';

class FakePlacesRemoteDataSource implements PlacesRemoteDataSource {
  List<PlaceModel> response = const [];
  double? latitude;
  double? longitude;
  int? radiusMeters;

  @override
  Future<List<PlaceModel>> fetchNearbyPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    this.latitude = latitude;
    this.longitude = longitude;
    this.radiusMeters = radiusMeters;
    return response;
  }
}

class FakePlacesRepository implements PlacesRepository {
  List<Place> result = const [];
  double? latitude;
  double? longitude;
  int? radiusMeters;

  @override
  Future<List<Place>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    this.latitude = latitude;
    this.longitude = longitude;
    this.radiusMeters = radiusMeters;
    return result;
  }
}

void main() {
  test('places repository forwards remote results', () async {
    final remote = FakePlacesRemoteDataSource()
      ..response = const [
        PlaceModel(id: '1', name: 'Cafe', latitude: 41.0, longitude: 29.0),
      ];
    final repository = PlacesRepositoryImpl(remote);

    final places = await repository.getNearbyPlaces(
      latitude: 41.0,
      longitude: 29.0,
      radiusMeters: 1000,
    );

    expect(places, hasLength(1));
    expect(places.first.name, 'Cafe');
    expect(remote.radiusMeters, 1000);
  });

  test('get nearby places usecase forwards query', () async {
    final repository = FakePlacesRepository();
    final useCase = GetNearbyPlaces(repository);

    await useCase(
      latitude: 41.0,
      longitude: 29.0,
      radiusMeters: 500,
    );

    expect(repository.latitude, 41.0);
    expect(repository.longitude, 29.0);
    expect(repository.radiusMeters, 500);
  });
}
