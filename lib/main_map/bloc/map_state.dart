part of 'map_bloc.dart';

class MapState extends Equatable {
  const MapState({
    required this.selectedStore,
    required this.latitude,
    required this.longitude,
    required this.regionMode,
    //  required this.baseRegion,
    required this.regionTiles,
    required this.minZoom,
    required this.maxZoom,
    this.preventRedownload = false,
    this.seaTileRemoval = true,
    this.disableRecovery = false,
  });

  final double latitude;
  final double longitude;
  final StoreDirectory? selectedStore;
  final RegionMode regionMode;
//  final BaseRegion? baseRegion;
  final int? regionTiles;
  final int minZoom;
  final int maxZoom;

  final bool preventRedownload;
  final bool seaTileRemoval;
  final bool disableRecovery;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        selectedStore,
        regionMode,
        //   baseRegion,
        regionTiles,
        minZoom,
        maxZoom,
        preventRedownload,
        seaTileRemoval,
        disableRecovery,
      ];

  MapState copyWith({
    double? latitude,
    double? longitude,
    StoreDirectory? selectedStore,
    RegionMode? regionMode,
    //  BaseRegion? baseRegion,
    int? regionTiles,
    int? minZoom,
    int? maxZoom,
    bool preventRedownload = false,
    bool seaTileRemoval = true,
    bool disableRecovery = false,
  }) {
    return MapState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedStore: selectedStore ?? this.selectedStore,
      regionMode: regionMode ?? this.regionMode,
      //  baseRegion: baseRegion ?? this.baseRegion,
      regionTiles: regionTiles ?? this.regionTiles,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      preventRedownload: preventRedownload,
      seaTileRemoval: seaTileRemoval,
      disableRecovery: disableRecovery,
    );
  }
}
