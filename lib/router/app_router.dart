import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/main_map/main_map.dart';
import 'package:flutter_maps/map_caching/download_region/download_region.dart';
import 'package:flutter_maps/map_caching/downloader/downloader.dart';
import 'package:flutter_maps/map_caching/downloading/downloading.dart';
import 'package:flutter_maps/map_caching/store_editor/store_editor.dart';
import 'package:flutter_maps/map_caching/stores/stores.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  main,
  homeMap,
  storesPage,
  storeEditorPopup,
  downloaderPage,
  downloadRegionPopup,
  downloadingPage,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/homeMap',
      name: AppRoute.homeMap.name,
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      path: '/storesPage',
      name: AppRoute.storesPage.name,
      builder: (context, state) => const StoresPage(),
    ),
    GoRoute(
        path: '/storeEditorPopup',
        name: AppRoute.storeEditorPopup.name,
        builder: (context, state) {
          final arguments = state.extra as Map<String, dynamic>;
          return StoreEditorPopup(
            existingStoreName: arguments['existingStoreName'] as String?,
            isStoreInUse: arguments['isStoreInUse'] as bool,
          );
        }),
    GoRoute(
      path: '/downloaderPage',
      name: AppRoute.downloaderPage.name,
      builder: (context, state) => const DownloaderPage(),
    ),
    GoRoute(
      path: '/downloadRegionPopup',
      name: AppRoute.downloadRegionPopup.name,
      builder: (context, state) => DownloadRegionPopup(
        region: state.extra! as BaseRegion,
      ),
    ),
    GoRoute(
      path: '/downloadingPage',
      name: AppRoute.downloadingPage.name,
      builder: (context, state) => const DownloadingPage(),
    ),
  ],
);
