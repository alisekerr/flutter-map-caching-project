import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/map_caching/map_caching.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachingHelper {
  Future<void> mainInital() async {
    final prefs = await SharedPreferences.getInstance();

    FlutterMapTileCaching.initialise(await RootDirectory.normalCache);
    await FMTC.instance.rootDirectory.migrator.fromV4();

    if (prefs.getBool('reset') ?? false) {
      await FMTC.instance.rootDirectory.manage.resetAsync();

      final instanceA = FMTC.instance('OpenStreetMap (A)');
      await instanceA.manage.createAsync();
      await instanceA.metadata.addAsync(
        key: 'sourceURL',
        value: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      );
      await instanceA.metadata.addAsync(
        key: 'validDuration',
        value: '14',
      );
      await instanceA.metadata.addAsync(
        key: 'behaviour',
        value: 'cacheFirst',
      );

      final instanceB = FMTC.instance('OpenStreetMap (B)');
      await instanceB.manage.createAsync();
      await instanceB.metadata.addAsync(
        key: 'sourceURL',
        value: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      );
      await instanceB.metadata.addAsync(
        key: 'validDuration',
        value: '14',
      );
      await instanceB.metadata.addAsync(
        key: 'behaviour',
        value: 'cacheFirst',
      );
    }
  }

  /*void loadStatistics({
    required bool withoutCachedStatistics,
    required Future<String>? tiles,
    required Future<String>? size,
    required Future<String>? cacheHits,
    required Future<String>? cacheMisses,
    required Future<Image?>? image,
    required StoreDirectory store,
  }) {
    final stats = !withoutCachedStatistics ? store.stats : store.stats.noCache;

    tiles = stats.storeLengthAsync.then((l) => l.toString());
    size = stats.storeSizeAsync.then((s) => (s * 1024).asReadableSize);
    cacheHits = stats.cacheHitsAsync.then((h) => h.toString());
    cacheMisses = stats.cacheMissesAsync.then((m) => m.toString());
    image = store.manage.tileImageAsync(randomRange: 20, size: 125);
  }*/

  List<FutureBuilder<String>> stats({
    required Future<String>? tiles,
    required Future<String>? size,
    required Future<String>? cacheHits,
    required Future<String>? cacheMisses,
    required Future<Image?>? image,
    required StoreDirectory store,
  }) {
    return [
      FutureBuilder<String>(
        future: tiles,
        builder: (context, snapshot) => StoreStatDisplay(
          statistic: snapshot.connectionState != ConnectionState.done
              ? null
              : snapshot.data,
          description: 'Total Tiles',
        ),
      ),
      FutureBuilder<String>(
        future: size,
        builder: (context, snapshot) => StoreStatDisplay(
          statistic: snapshot.connectionState != ConnectionState.done
              ? null
              : snapshot.data,
          description: 'Total Size',
        ),
      ),
      FutureBuilder<String>(
        future: cacheHits,
        builder: (context, snapshot) => StoreStatDisplay(
          statistic: snapshot.connectionState != ConnectionState.done
              ? null
              : snapshot.data,
          description: 'Cache Hits',
        ),
      ),
      FutureBuilder<String>(
        future: cacheMisses,
        builder: (context, snapshot) => StoreStatDisplay(
          statistic: snapshot.connectionState != ConnectionState.done
              ? null
              : snapshot.data,
          description: 'Cache Misses',
        ),
      ),
    ];
  }
}
