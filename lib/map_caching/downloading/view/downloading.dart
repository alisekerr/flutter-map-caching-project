import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/main_map/bloc/map_bloc.dart';
import 'package:flutter_maps/map_caching/downloading/view/download_statistics.dart';
import 'package:flutter_maps/map_caching/downloading/widgets/downloading_header.dart';
import 'package:flutter_maps/router/app_router.dart';

class DownloadingPage extends StatefulWidget {
  const DownloadingPage({super.key});

  @override
  State<DownloadingPage> createState() => _DownloadingPageState();
}

class _DownloadingPageState extends State<DownloadingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DownloadingHeader(),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: BlocBuilder<MapBloc, MapState>(
                      builder: (context, state) =>
                          StreamBuilder<DownloadProgress>(
                        stream: context.read<MapBloc>().downloadProgress,
                        initialData: DownloadProgress.empty(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            context.read<MapBloc>().downloadProgress = null;

                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => goRouter.pop(),
                            );
                          }

                          return DownloadStatistics(data: snapshot.data!);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
