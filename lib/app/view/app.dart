import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_maps/l10n/l10n.dart';
import 'package:flutter_maps/main_map/main_map.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/router/app_router.dart';
import 'package:flutter_maps/theme/theme.dart';
import 'package:locations_repository/locations_repository.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    LocationsRepository? locationsRepository,
  }) : _locationsRepository = locationsRepository;

  final LocationsRepository? _locationsRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget._locationsRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapBloc(),
          ),
          BlocProvider(
            create: (context) => GeneralBloc(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: goRouter,
        ),
      ),
    );
  }
}
