import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/downloader/downloader.dart';
import 'package:flutter_maps/location_input/location_input.dart';
import 'package:flutter_maps/map/map.dart';

import 'package:flutter_maps/stores/stores.dart';

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
              children: [
                MapWidget(
                  key: Key('map${state.latitude}${state.longitude}'),
                  latitude: state.latitude,
                  longitude: state.longitude,
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<String>(
                                  builder: (BuildContext context) =>
                                      const StoresPage(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: const Text('Caching'),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<String>(
                                  builder: (BuildContext context) =>
                                      const DownloaderPage(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: const Text('Caching Map and Downloading'),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
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
