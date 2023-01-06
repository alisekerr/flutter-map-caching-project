import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/download_region/download_region.dart';
import 'package:flutter_maps/downloader/components/header.dart';
import 'package:flutter_maps/downloader/components/map_view.dart';
import 'package:flutter_maps/map/map.dart';

class DownloaderPage extends StatefulWidget {
  const DownloaderPage({super.key});

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Header(),
              ),
            ),
            Expanded(
              child: SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: MediaQuery.of(context).size.width <= 950
                        ? const Radius.circular(20)
                        : Radius.zero,
                  ),
                  child: const MapView(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) => FloatingActionButton.extended(
            onPressed: state.baseRegion == null || state.regionTiles == null
                ? () {}
                : () => Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (BuildContext context) =>
                            DownloadRegionPopup(region: state.baseRegion!),
                        fullscreenDialog: true,
                      ),
                    ),
            icon: const Icon(Icons.arrow_forward),
            label: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: state.regionTiles == null
                  ? SizedBox(
                      height: 36,
                      width: 36,
                      child: Center(
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    )
                  : Text('~${state.regionTiles} tiles'),
            ),
          ),
        ),
      );
}
