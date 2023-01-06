import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/theme/theme.dart';
import 'package:latlong2/latlong.dart';

import '../../stores/components/loading_indicator.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    final _searchingPoint = LatLng(
      widget.latitude,
      widget.longitude,
    );

    return BlocBuilder<GeneralBloc, GeneralState>(
      builder: (context, state) {
        return FutureBuilder<Map<String, String>?>(
          future: state.currentStore == ''
              ? Future.sync(() => {})
              : FMTC.instance(state.currentStore!).metadata.readAsync,
          builder: (context, metadata) {
            if (!metadata.hasData ||
                metadata.data == null ||
                (state.currentStore != '' && metadata.data!.isEmpty)) {
              return const LoadingIndicator(
                message:
                    'Loading Settings...\n\nSeeing this screen for a long time?\nThere may be a misconfiguration of the\nstore. Try disabling caching and deleting\n faulty stores.',
              );
            }

            final urlTemplate =
                state.currentStore != '' && metadata.data != null
                    ? metadata.data!['sourceURL']!
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

            return FlutterMap(
              options: MapOptions(
                center: _searchingPoint,
                zoom: 9.2,
                maxBounds: LatLngBounds.fromPoints([
                  LatLng(-90, 180),
                  LatLng(90, 180),
                  LatLng(90, -180),
                  LatLng(-90, -180),
                ]),
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                keepAlive: true,
                maxZoom: 16,
                minZoom: 2,
                onTap: (tapPosition, point) async {},
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: Uri.parse(urlTemplate).host,
                ),
              ],
              children: [
                TileLayer(
                  errorImage: const NetworkImage(
                      'https://tile.openstreetmap.org/18/0/0.png'),
                  //retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
                  urlTemplate: urlTemplate,
                  tileProvider: state.currentStore != ''
                      ? FMTC.instance(state.currentStore!).getTileProvider(
                            FMTCTileProviderSettings(
                              behavior: CacheBehavior.values
                                  .byName(metadata.data!['behaviour']!),
                              cachedValidDuration: int.parse(
                                        metadata.data!['validDuration']!,
                                      ) ==
                                      0
                                  ? Duration.zero
                                  : Duration(
                                      days: int.parse(
                                        metadata.data!['validDuration']!,
                                      ),
                                    ),
                            ),
                          )
                      : NetworkNoRetryTileProvider(),
                  userAgentPackageName: 'com.example.app',
                  tileBuilder: (context, tileWidget, tile) {
                    const greyscale = ColorFilter.matrix(<double>[
                      /*  0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,*/
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      1,
                    ]);

                    return ColorFiltered(
                      colorFilter: greyscale,
                      child: tileWidget,
                    );
                  },
                ),
                MarkerLayer(
                  markers: [
                    _searchingPointMarker(
                      latLng: _searchingPoint,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Marker _searchingPointMarker({required LatLng latLng}) {
    return Marker(
      point: latLng,
      builder: _searchingPointMarkerBuilder,
    );
  }

  Widget _searchingPointMarkerBuilder(BuildContext context) {
    return const Icon(
      Icons.place,
      size: 40,
      color: AppColors.red,
    );
  }
}
