import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/vars/region_mode.dart';

part 'map_event.dart';
part 'map_state.dart';

const _initialLat = 41.015137;
const _initialLong = 28.979530;

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc()
      : super(
          const MapState(
            latitude: _initialLat,
            longitude: _initialLong,
            selectedStore: null,
            // baseRegion: null,
            regionTiles: 0,
            regionMode: RegionMode.circle,
            minZoom: 1,
            maxZoom: 16,
          ),
        ) {
    on<StoreDirectorySet>(_onStoreDirectorySet);
    on<RegionModeSet>(_onRegionModeSet);
    //  on<BaseRegionSet>(_onBaseRegionSet);
    on<RegionTilesSet>(_onRegionTilesSet);
    on<MinZoomSet>(_onMinZoomSet);
    on<MaxZoomSet>(_onMaxZoomSet);

    on<PreventRedownloadSet>(_onPreventRedownloadSet);
    on<SeaTileRemovalSet>(_onSeaTileRemovalSet);
    on<DisableRecoverySet>(_onDisableRecoverySet);
    on<ShowLocation>(_onShowLocation);
  }

  Stream<DownloadProgress>? downloadProgress;

  final StreamController<void> _manualPolygonRecalcTrigger =
      StreamController.broadcast();
  StreamController<void> get manualPolygonRecalcTrigger =>
      _manualPolygonRecalcTrigger;
  void triggerManualPolygonRecalc() => _manualPolygonRecalcTrigger.add(null);
  BaseRegion? baseRegion;
  void _onStoreDirectorySet(
    StoreDirectorySet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        selectedStore: event.newStore,
      ),
    );
  }

  void _onRegionModeSet(
    RegionModeSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        regionMode: event.regionMode,
      ),
    );
  }

  /* void _onBaseRegionSet(
    BaseRegionSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        baseRegion: event.baseRegion,
      ),
    );
  }*/

  void _onRegionTilesSet(
    RegionTilesSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        regionTiles: event.regionTiles,
      ),
    );
  }

  void _onMinZoomSet(
    MinZoomSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        minZoom: event.minZoom,
      ),
    );
  }

  void _onMaxZoomSet(
    MaxZoomSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        maxZoom: event.maxZoom,
      ),
    );
  }

  void _onPreventRedownloadSet(
    PreventRedownloadSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        preventRedownload: event.preventRedownload,
      ),
    );
  }

  void _onSeaTileRemovalSet(
    SeaTileRemovalSet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        seaTileRemoval: event.seaTileRemoval,
      ),
    );
  }

  void _onDisableRecoverySet(
    DisableRecoverySet event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        disableRecovery: event.disableRecovery,
      ),
    );
  }

  void _onShowLocation(
    ShowLocation event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );
  }
}
