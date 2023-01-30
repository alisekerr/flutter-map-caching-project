import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/app/app.dart';
import 'package:flutter_maps/bootstrap.dart';
import 'package:flutter_maps/caching_helper/caching_helper.dart';
import 'package:location_api_client/location_api_client.dart';
import 'package:locations_repository/locations_repository.dart';
import 'package:path/path.dart' as p;

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
  final cachingHelper = CachingHelper();

  await cachingHelper.mainInital();

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
