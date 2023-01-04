import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

import '../../vars/region_mode.dart';

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
            baseRegion: null,
            regionTiles: 0,
            downloadProggres: null,
          ),
        ) {
    on<StoreDirectorySet>(_onStoreDirectorySet);
    on<ShowLocation>(_onShowLocation);
  }

// final StreamController<void> resetController = StreamController.broadcast();

  final StreamController<void> _manualPolygonRecalcTrigger =
      StreamController.broadcast();
  StreamController<void> get manualPolygonRecalcTrigger =>
      _manualPolygonRecalcTrigger;
  void triggerManualPolygonRecalc() => _manualPolygonRecalcTrigger.add(null);

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
