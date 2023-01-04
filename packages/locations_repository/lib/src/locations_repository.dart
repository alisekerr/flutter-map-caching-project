import 'package:location_api_client/location_api_client.dart';
import 'package:locations_repository/locations_repository.dart';

/// Flutter package that handles locations related requests
class LocationsRepository {
  /// {@macro locations_repository}
  const LocationsRepository({required LocationApiClient locationApiClient})
      : _locationApiClient = locationApiClient;

  final LocationApiClient _locationApiClient;

  /// get locations that matches given name
  Future<List<Location>> getLocations({required String location}) async {
    final locations = <Location>[];
    final locationsData =
        await _locationApiClient.getLocations(location: location);

    for (final data in locationsData) {
      locations.add(
        Location.fromLocationData(data),
      );
    }
    return locations;
  }
}
