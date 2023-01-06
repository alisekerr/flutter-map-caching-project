import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_maps/l10n/l10n.dart';
import 'package:flutter_maps/map/map.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/theme/theme.dart';
import 'package:locations_repository/locations_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required LocationsRepository locationsRepository,
  }) : _locationsRepository = locationsRepository;

  final LocationsRepository _locationsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _locationsRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapBloc(),
          ),
          BlocProvider(
            create: (context) => GeneralBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MapPage(),
        ),
      ),
    );
  }
}
