import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/main_map/main_map.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';

class StoreSelector extends StatefulWidget {
  const StoreSelector({super.key});

  @override
  State<StoreSelector> createState() => _StoreSelectorState();
}

class _StoreSelectorState extends State<StoreSelector> {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CHOOSE STORE'),
          BlocBuilder<MapBloc, MapState>(
            builder: (context, state) => BlocBuilder<GeneralBloc, GeneralState>(
              builder: (context, generalState) {
                return FutureBuilder<List<StoreDirectory>>(
                  future:
                      FMTC.instance.rootDirectory.stats.storesAvailableAsync,
                  builder: (context, snapshot) {
                    return DropdownButton<StoreDirectory>(
                      items: snapshot.data
                          ?.map(
                            (e) => DropdownMenuItem<StoreDirectory>(
                              value: e,
                              child: Text(e.storeName),
                            ),
                          )
                          .toList(),
                      onChanged: (store) =>
                          context.read<MapBloc>().add(StoreDirectorySet(store)),
                      value: state.selectedStore?.storeName == ''
                          ? null
                          : state.selectedStore ??
                              (generalState.currentStore == ''
                                  ? null
                                  : FMTC.instance(generalState.currentStore!)),
                      isExpanded: true,
                      hint: Text(
                        snapshot.data == null
                            ? 'Loading...'
                            : snapshot.data!.isEmpty
                                ? 'None Available'
                                : 'None Selected',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
}
