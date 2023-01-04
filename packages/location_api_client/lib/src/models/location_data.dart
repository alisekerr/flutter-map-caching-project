import 'package:json_annotation/json_annotation.dart';

part 'location_data.g.dart';

@JsonSerializable(createToJson: false)

/// LocationData model which include location: name, label, latitude, longitude
class LocationData {
  /// const constructor of the LocationData model
  const LocationData({
    required this.name,
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  /// it returns LocationData from json
  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  /// location name [String]
  final String name;

  /// location label [String]
  final String label;

  /// location latitude [double]
  final double latitude;

  /// location longitude [double]
  final double longitude;
}
