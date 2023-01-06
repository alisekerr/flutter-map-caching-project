import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/downloader/components/crosshairs.dart';
import 'package:flutter_maps/map/map.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/stores/components/loading_indicator.dart';
import 'package:flutter_maps/vars/region_mode.dart';
import 'package:latlong2/latlong.dart';

import 'package:stream_transform/stream_transform.dart';

class MapView extends StatefulWidget {
  const MapView({
    super.key,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const double _shapePadding = 15;
  static const _crosshairsMovement = Point<double>(10, 10);

  final _mapKey = GlobalKey<State<StatefulWidget>>();
  final MapController _mapController = MapController();

  late final StreamSubscription _polygonVisualizerStream;
  late final StreamSubscription _tileCounterTriggerStream;
  late final StreamSubscription _manualPolygonRecalcTriggerStream;

  Point<double>? _crosshairsTop;
  Point<double>? _crosshairsBottom;
  LatLng? _coordsTopLeft;
  LatLng? _coordsBottomRight;
  LatLng? _center;
  double? _radius;

  PolygonLayer _buildTargetPolygon(BaseRegion region) => PolygonLayer(
        polygons: [
          Polygon(
            points: [
              LatLng(-90, 180),
              LatLng(90, 180),
              LatLng(90, -180),
              LatLng(-90, -180),
            ],
            holePointsList: [region.toList()],
            isFilled: true,
            borderColor: Colors.black,
            borderStrokeWidth: 2,
            color: Colors.white.withOpacity(2 / 3),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();

    /*SchedulerBinding.instance.addPostFrameCallback((_) {
     
    });*/
    _manualPolygonRecalcTriggerStream =
        context.read<MapBloc>().manualPolygonRecalcTrigger.stream.listen((_) {
      _updatePointLatLng();
      _countTiles();
    });
    _polygonVisualizerStream =
        _mapController.mapEventStream.listen((_) => _updatePointLatLng());
    _tileCounterTriggerStream = _mapController.mapEventStream
        .debounce(const Duration(seconds: 1))
        .listen((_) => _countTiles());
  }

  @override
  void dispose() {
    super.dispose();

    _polygonVisualizerStream.cancel();
    _tileCounterTriggerStream.cancel();
    _manualPolygonRecalcTriggerStream.cancel();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<GeneralBloc, GeneralState>(
        key: _mapKey,
        builder: (context, generalState) => BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return FutureBuilder<Map<String, String>?>(
              future: generalState.currentStore == ''
                  ? Future.sync(() => {})
                  : FMTC
                      .instance(generalState.currentStore!)
                      .metadata
                      .readAsync,
              builder: (context, metadata) {
                if (!metadata.hasData ||
                    metadata.data == null ||
                    (generalState.currentStore != '' &&
                        (metadata.data ?? {}).isEmpty)) {
                  return const LoadingIndicator(
                    message:
                        'Loading Settings...\n\nSeeing this screen for a long time?\nThere may be a misconfiguration of the\nstore. Try disabling caching and deleting\n faulty stores.',
                  );
                }

                final urlTemplate =
                    generalState.currentStore != '' && metadata.data != null
                        ? metadata.data!['sourceURL']!
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

                return Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: LatLng(41.015137, 28.979530),
                        zoom: 9.2,
                        interactiveFlags:
                            InteractiveFlag.all & ~InteractiveFlag.rotate,
                        keepAlive: true,
                        onMapReady: () {
                          _updatePointLatLng();
                          _countTiles();
                        },
                      ),
                      nonRotatedChildren: [
                        AttributionWidget.defaultWidget(
                          source: Uri.parse(urlTemplate).host,
                          alignment: Alignment.bottomLeft,
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate: urlTemplate,
                          maxZoom: 20,
                          reset: context
                              .read<GeneralBloc>()
                              .resetController
                              .stream,
                          keepBuffer: 5,
                          backgroundColor: const Color(0xFFaad3df),
                          tileBuilder: (context, widget, tile) =>
                              FutureBuilder<bool?>(
                            future: generalState.currentStore == '' //aaa
                                ? Future.sync(() => null)
                                : FMTC
                                    .instance(generalState.currentStore!)
                                    .getTileProvider()
                                    .checkTileCachedAsync(
                                      coords: tile.coords,
                                      options: TileLayer(
                                        urlTemplate: urlTemplate,
                                      ),
                                    ),
                            builder: (context, snapshot) => DecoratedBox(
                              position: DecorationPosition.foreground,
                              decoration: BoxDecoration(
                                color: (snapshot.data ?? false)
                                    ? Colors.deepOrange.withOpacity(0.33)
                                    : Colors.transparent,
                              ),
                              child: widget,
                            ),
                          ),
                        ),
                        if (_coordsTopLeft != null &&
                            _coordsBottomRight != null &&
                            state.regionMode != RegionMode.circle)
                          _buildTargetPolygon(
                            RectangleRegion(
                              LatLngBounds(_coordsTopLeft, _coordsBottomRight),
                            ),
                          )
                        else if (_center != null &&
                            _radius != null &&
                            state.regionMode == RegionMode.circle)
                          _buildTargetPolygon(CircleRegion(_center!, _radius!))
                      ],
                    ),
                    if (_crosshairsTop != null &&
                        _crosshairsBottom != null) ...[
                      Positioned(
                        top: _crosshairsTop!.y,
                        left: _crosshairsTop!.x,
                        child: const Crosshairs(),
                      ),
                      Positioned(
                        top: _crosshairsBottom!.y,
                        left: _crosshairsBottom!.x,
                        child: const Crosshairs(),
                      ),
                    ]
                  ],
                );
              },
            );
          },
        ),
      );

  void _updatePointLatLng() {
    final mapSize = _mapKey.currentContext!.size!;
    final isHeightLongestSide = mapSize.width < mapSize.height;

    final centerNormal = Point<double>(mapSize.width / 2, mapSize.height / 2);
    final centerInversed = Point<double>(mapSize.height / 2, mapSize.width / 2);

    late final Point<double> calculatedTopLeft;
    late final Point<double> calculatedBottomRight;

    switch (context.read<MapBloc>().state.regionMode) {
      case RegionMode.square:
        final offset = (mapSize.shortestSide - (_shapePadding * 2)) / 2;

        calculatedTopLeft = Point<double>(
          centerNormal.x - offset,
          centerNormal.y - offset,
        );
        calculatedBottomRight = Point<double>(
          centerNormal.x + offset,
          centerNormal.y + offset,
        );
        break;
      case RegionMode.rectangleVertical:
        final allowedArea = Size(
          mapSize.width - (_shapePadding * 2),
          (mapSize.height - (_shapePadding * 2)) / 1.5 - 50,
        );

        calculatedTopLeft = Point<double>(
          centerInversed.y - allowedArea.shortestSide / 2,
          _shapePadding,
        );
        calculatedBottomRight = Point<double>(
          centerInversed.y + allowedArea.shortestSide / 2,
          mapSize.height - _shapePadding - 25,
        );
        break;
      case RegionMode.rectangleHorizontal:
        final allowedArea = Size(
          mapSize.width - (_shapePadding * 2),
          (mapSize.width < mapSize.height + 250)
              ? (mapSize.width - (_shapePadding * 2)) / 1.75
              : (mapSize.height - (_shapePadding * 2) - 0),
        );

        calculatedTopLeft = Point<double>(
          _shapePadding,
          centerNormal.y - allowedArea.height / 2,
        );
        calculatedBottomRight = Point<double>(
          mapSize.width - _shapePadding,
          centerNormal.y + allowedArea.height / 2 - 25,
        );
        break;
      case RegionMode.circle:
        final allowedArea =
            Size.square(mapSize.shortestSide - (_shapePadding * 2));

        final calculatedTop = Point<double>(
          centerNormal.x,
          (isHeightLongestSide ? centerNormal.y : centerInversed.x) -
              allowedArea.width / 2,
        );

        _crosshairsTop = calculatedTop - _crosshairsMovement;
        _crosshairsBottom = centerNormal - _crosshairsMovement;

        _center =
            _mapController.pointToLatLng(_customPointFromPoint(centerNormal));
        _radius = const Distance(roundResult: false).distance(
              _center!,
              _mapController
                  .pointToLatLng(_customPointFromPoint(calculatedTop))!,
            ) /
            1000;
        setState(() {});
        break;
    }

    if (context.read<MapBloc>().state.regionMode != RegionMode.circle) {
      _crosshairsTop = calculatedTopLeft - _crosshairsMovement;
      _crosshairsBottom = calculatedBottomRight - _crosshairsMovement;

      _coordsTopLeft = _mapController
          .pointToLatLng(_customPointFromPoint(calculatedTopLeft));
      _coordsBottomRight = _mapController
          .pointToLatLng(_customPointFromPoint(calculatedBottomRight));

      setState(() {});
    }
    context.read<MapBloc>().state.regionMode == RegionMode.circle
        ? context
            .read<MapBloc>()
            .add(BaseRegionSet(CircleRegion(_center!, _radius!)))
        : context.read<MapBloc>().add(
              BaseRegionSet(
                RectangleRegion(
                  LatLngBounds(_coordsTopLeft, _coordsBottomRight),
                ),
              ),
            );
  }

  Future<void> _countTiles() async {
    if (context.read<MapBloc>().state.baseRegion != null) {
      context.read<MapBloc>().add(const RegionTilesSet(null));
      context.read<MapBloc>().add(
            RegionTilesSet(
              await FMTC.instance('').download.check(
                    context.read<MapBloc>().state.baseRegion!.toDownloadable(
                          context.read<MapBloc>().state.minZoom,
                          context.read<MapBloc>().state.maxZoom,
                          TileLayer(),
                        ),
                  ),
            ),
          );
    }
  }
}

CustomPoint<E> _customPointFromPoint<E extends num>(Point<E> point) =>
    CustomPoint(point.x, point.y);
