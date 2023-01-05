import 'package:locations_repository/locations_repository.dart';

class LocationInputService {
  const LocationInputService({
    required this.locationsRepository,
  });
  final LocationsRepository locationsRepository;

  Future<List<Location>> getSuggestions(String searchingWord) async {
    if (searchingWord.length >= 3) {
      final suggestions = await locationsRepository.getLocations(
        location: searchingWord,
      );
      return suggestions;
    }
    return [];
  }
}
