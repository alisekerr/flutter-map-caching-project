import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/location_input/location_input.dart';
import 'package:flutter_maps/main_map/bloc/map_bloc.dart';
import 'package:flutter_maps/main_map/widgets/widgets.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapView();
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return FMTCBackgroundDownload(
          child: Scaffold(
            body: Stack(
              // alignment: AlignmentDirectional.centerStart,
              children: [
                MapWidget(
                  key: Key('map${state.latitude}${state.longitude}'),
                  latitude: state.latitude,
                  longitude: state.longitude,
                ),
                const StoreAndCachingWidget(),
              ],
            ),
            floatingActionButton: LocationInput(
              onSelected: (location) {
                context.read<MapBloc>().add(
                      ShowLocation(
                        latitude: location.latitude,
                        longitude: location.longitude,
                      ),
                    );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerTop,
          ),
        );
      },
    );
  }
}
