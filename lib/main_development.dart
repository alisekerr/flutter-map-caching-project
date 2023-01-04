import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/app/app.dart';
import 'package:flutter_maps/bootstrap.dart';
import 'package:location_api_client/location_api_client.dart';
import 'package:locations_repository/locations_repository.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locationApiClient = LocationApiClient();
  final locationsRepository = LocationsRepository(
    locationApiClient: locationApiClient,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
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

  final newAppVersionFile = File(
    p.join(
      FMTC.instance.rootDirectory.access.real.path,
      'newAppVersion.${Platform.isWindows ? 'exe' : 'apk'}',
    ),
  );
  if (await newAppVersionFile.exists()) await newAppVersionFile.delete();
  await bootstrap(
    () => App(
      locationsRepository: locationsRepository,
    ),
  );
}
