import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/download_region/components/bd_battery_optimizations_info.dart';
import 'package:flutter_maps/download_region/components/optional_functionality.dart';
import 'package:flutter_maps/download_region/components/region_information.dart';
import 'package:flutter_maps/download_region/components/section_separator.dart';
import 'package:flutter_maps/download_region/components/store_selector.dart';
import 'package:flutter_maps/download_region/components/usage_warning.dart';
import 'package:flutter_maps/downloading/downloading.dart';
import 'package:flutter_maps/map/map.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadRegionPopup extends StatefulWidget {
  const DownloadRegionPopup({
    super.key,
    required this.region,
  });

  final BaseRegion region;

  @override
  State<DownloadRegionPopup> createState() => _DownloadRegionPopupState();
}

class _DownloadRegionPopupState extends State<DownloadRegionPopup> {
  late final CircleRegion? circleRegion;
  late final RectangleRegion? rectangleRegion;

  @override
  void initState() {
    if (widget.region is CircleRegion) {
      circleRegion = widget.region as CircleRegion;
      rectangleRegion = null;
    } else {
      rectangleRegion = widget.region as RectangleRegion;
      circleRegion = null;
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final currentStore = context.read<GeneralBloc>().state.currentStore;
    if (currentStore != null) {
      context
          .read<MapBloc>()
          .add(StoreDirectorySet(FMTC.instance(currentStore)));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Download Region'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegionInformation(
                    widget: widget,
                    circleRegion: circleRegion,
                    rectangleRegion: rectangleRegion,
                  ),
                  const SectionSeparator(),
                  const StoreSelector(),
                  const SectionSeparator(),
                  const OptionalFunctionality(),
                  const SectionSeparator(),
                  const BackgroundDownloadBatteryOptimizationsInfo(),
                  const SectionSeparator(),
                  const UsageWarning(),
                  const SectionSeparator(),
                  const Text('START DOWNLOAD IN'),
                  BlocBuilder<MapBloc, MapState>(
                    builder: (context, downloadState) =>
                        BlocBuilder<GeneralBloc, GeneralState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: downloadState.selectedStore ==
                                            null ||
                                        downloadState
                                                .selectedStore?.storeName ==
                                            ''
                                    ? null
                                    : () async {
                                        final metadata = await downloadState
                                            .selectedStore!.metadata.readAsync;

                                        if (mounted) {
                                          context
                                                  .read<MapBloc>()
                                                  .downloadProgress =
                                              downloadState
                                                  .selectedStore!.download
                                                  .startForeground(
                                                    region: widget.region
                                                        .toDownloadable(
                                                      downloadState.minZoom,
                                                      downloadState.maxZoom,
                                                      TileLayer(
                                                        urlTemplate: metadata[
                                                            'sourceURL'],
                                                      ),
                                                      preventRedownload:
                                                          downloadState
                                                              .preventRedownload,
                                                      seaTileRemoval:
                                                          downloadState
                                                              .seaTileRemoval,
                                                      parallelThreads:
                                                          (await SharedPreferences
                                                                          .getInstance())
                                                                      .getBool(
                                                                    'bypassDownloadThreadsLimitation',
                                                                  ) ??
                                                                  false
                                                              ? 10
                                                              : 2,
                                                    ),
                                                    disableRecovery:
                                                        downloadState
                                                            .disableRecovery,
                                                  )
                                                  .asBroadcastStream();
                                          await Navigator.of(context).push(
                                            MaterialPageRoute<String>(
                                              builder: (
                                                BuildContext context,
                                              ) =>
                                                  const DownloadingPage(),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                        }
                                      },
                                child: const Text('Foreground'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: downloadState.selectedStore == null
                                    ? null
                                    : () async {
                                        final metadata = await downloadState
                                            .selectedStore!.metadata.readAsync;

                                        await downloadState
                                            .selectedStore!.download
                                            .startBackground(
                                          region: widget.region.toDownloadable(
                                            downloadState.minZoom,
                                            downloadState.maxZoom,
                                            TileLayer(
                                              urlTemplate:
                                                  metadata['sourceURL'],
                                            ),
                                            preventRedownload:
                                                downloadState.preventRedownload,
                                            seaTileRemoval:
                                                downloadState.seaTileRemoval,
                                            parallelThreads:
                                                (await SharedPreferences
                                                                .getInstance())
                                                            .getBool(
                                                          'bypassDownloadThreadsLimitation',
                                                        ) ??
                                                        false
                                                    ? 10
                                                    : 2,
                                          ),
                                          disableRecovery:
                                              downloadState.disableRecovery,
                                          progressNotificationIcon:
                                              '@mipmap/ic_launcher',
                                          backgroundNotificationIcon:
                                              const AndroidResource(
                                            name: 'ic_launcher',
                                            defType: 'mipmap',
                                          ),
                                        );

                                        if (mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                child: const Text('Background'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
