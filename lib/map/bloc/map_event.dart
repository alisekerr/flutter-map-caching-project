part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class StoreDirectorySet extends MapEvent {
  const StoreDirectorySet(this.newStore);

  final StoreDirectory? newStore;
}

class RegionModeSet extends MapEvent {
  const RegionModeSet(this.regionMode);

  final RegionMode? regionMode;
}

class BaseRegionSet extends MapEvent {
  const BaseRegionSet(this.baseRegion);

  final BaseRegion? baseRegion;
}

class RegionTilesSet extends MapEvent {
  const RegionTilesSet(this.regionTiles);

  final int regionTiles;
}

class MinZoomSet extends MapEvent {
  const MinZoomSet(this.minZoom);

  final int minZoom;
}

class MaxZoomSet extends MapEvent {
  const MaxZoomSet(this.maxZoom);

  final int maxZoom;
}

class DownloadProggresSet extends MapEvent {
  const DownloadProggresSet(this.downloadProgress);

  final Stream<DownloadProgress>? downloadProgress;
}

class PreventRedownloadSet extends MapEvent {
  const PreventRedownloadSet(this.preventRedownload);

  final bool preventRedownload;
}

class SeaTileRemovalSet extends MapEvent {
  const SeaTileRemovalSet(this.seaTileRemoval);

  final bool seaTileRemoval;
}

class DisableRecoverySet extends MapEvent {
  const DisableRecoverySet(this.disableRecovery);

  final bool disableRecovery;
}

class ShowLocation extends MapEvent {
  const ShowLocation({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
}
