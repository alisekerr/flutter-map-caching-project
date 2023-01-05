import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_maps/theme/theme.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_map_tile_caching/fmtc_advanced.dart';

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

    return FlutterMap(
      options: MapOptions(
        center: _searchingPoint,
        zoom: 12,
        keepAlive: true,
        maxZoom: 13,
        minZoom: 12,
        onTap: (tapPosition, point) async {},
      ),
      children: [
        TileLayer(
          errorImage:
              const NetworkImage('https://tile.openstreetmap.org/18/0/0.png'),
          //retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          tileBuilder: (context, tileWidget, tile) {
            const ColorFilter greyscale = ColorFilter.matrix(<double>[
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

            return ColorFiltered(colorFilter: greyscale, child: tileWidget);
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
