import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/map_caching/store_editor/view/store_editor.dart';
import 'package:flutter_maps/map_caching/stores/widgets/empty_indicator.dart';
import 'package:flutter_maps/map_caching/stores/widgets/header.dart';
import 'package:flutter_maps/map_caching/stores/widgets/loading_indicator.dart';
import 'package:flutter_maps/map_caching/stores/widgets/store_tile.dart';
import 'package:flutter_maps/router/app_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  late Future<List<StoreDirectory>> _stores;

  @override
  void initState() {
    super.initState();

    void listStores() =>
        _stores = FMTC.instance.rootDirectory.stats.storesAvailableAsync;

    listStores();

    FMTC.instance.rootDirectory.stats.watchChanges(
      rootParts: [RootParts.stores],
    ).listen((_) {
      if (mounted) {
        listStores();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<StoreDirectory>>(
                  future: _stores,
                  builder: (context, snapshot) => snapshot.hasData
                      ? snapshot.data!.isEmpty
                          ? const EmptyIndicator()
                          : ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return StoreTile(
                                  context: context,
                                  storeName: snapshot.data![index].storeName,
                                  key: ValueKey(
                                    snapshot.data![index].storeName,
                                  ),
                                );
                              },
                            )
                      : const LoadingIndicator(
                          message: 'Loading Stores...',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatActionButton(),
    );
  }

  SpeedDial buildFloatActionButton() {
    return SpeedDial(
      icon: Icons.create_new_folder,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
          onTap: () => goRouter.pushNamed(
            'storeEditorPopup',
            extra: {
              'existingStoreName': null,
              'isStoreInUse': false,
            },
          ),
          child: const Icon(Icons.add),
          label: 'Create New Store',
        ),
      ],
    );
  }
}
