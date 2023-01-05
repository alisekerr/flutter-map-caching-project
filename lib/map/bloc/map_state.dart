part of 'map_bloc.dart';

class MapState extends Equatable {
  const MapState({
    required this.selectedStore,
    required this.latitude,
    required this.longitude,
    this.regionMode = RegionMode.square,
    required this.baseRegion,
    required this.regionTiles,
    this.minZoom = 1,
    this.maxZoom = 16,
    required this.downloadProggres,
    this.preventRedownload = false,
    this.seaTileRemoval = true,
    this.disableRecovery = false,
  });

  final double latitude;
  final double longitude;
  final StoreDirectory? selectedStore;
  final RegionMode regionMode;
  final BaseRegion? baseRegion;
  final int regionTiles;
  final int minZoom;
  final int maxZoom;
  final Stream<DownloadProgress>? downloadProggres;
  final bool preventRedownload;
  final bool seaTileRemoval;
  final bool disableRecovery;

  @override
  List<Object> get props => [
        latitude,
        longitude,
      ];

  MapState copyWith({
    double? latitude,
    double? longitude,
    StoreDirectory? selectedStore,
    RegionMode regionMode = RegionMode.square,
    BaseRegion? baseRegion,
    int? regionTiles,
    int minZoom = 1,
    int maxZoom = 16,
    Stream<DownloadProgress>? downloadProggres,
    bool preventRedownload = false,
    bool seaTileRemoval = true,
    bool disableRecovery = false,
  }) {
    return MapState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedStore: selectedStore ?? this.selectedStore,
      regionMode: regionMode,
      baseRegion: baseRegion ?? this.baseRegion,
      regionTiles: regionTiles ?? this.regionTiles,
      minZoom: minZoom,
      maxZoom: maxZoom,
      downloadProggres: downloadProggres ?? this.downloadProggres,
      preventRedownload: preventRedownload,
      seaTileRemoval: seaTileRemoval,
      disableRecovery: disableRecovery,
    );
  }
}
