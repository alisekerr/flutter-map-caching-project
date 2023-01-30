import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/caching_helper/caching_helper.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/map_caching/stores/widgets/invalid_store.dart';
import 'package:flutter_maps/router/app_router.dart';

import 'package:flutter_maps/vars/size_formatter.dart';

class StoreTile extends StatefulWidget {
  const StoreTile({
    super.key,
    required this.context,
    required this.storeName,
  });

  final BuildContext context;
  final String storeName;

  @override
  State<StoreTile> createState() => _StoreTileState();
}

class _StoreTileState extends State<StoreTile> {
  Future<String>? _tiles;
  Future<String>? _size;
  Future<String>? _cacheHits;
  Future<String>? _cacheMisses;
  Future<Image?>? _image;

  bool _deletingProgress = false;
  bool _emptyingProgress = false;
  bool _exportingProgress = false;

  late final _store = FMTC.instance(widget.storeName);
  CachingHelper cachingHelper = CachingHelper();
  void _loadStatistics({bool withoutCachedStatistics = false}) {
    final stats =
        !withoutCachedStatistics ? _store.stats : _store.stats.noCache;

    _tiles = stats.storeLengthAsync.then((l) => l.toString());
    _size = stats.storeSizeAsync.then((s) => (s * 1024).asReadableSize);
    _cacheHits = stats.cacheHitsAsync.then((h) => h.toString());
    _cacheMisses = stats.cacheMissesAsync.then((m) => m.toString());
    _image = _store.manage.tileImageAsync(randomRange: 20, size: 125);

    setState(() {});
  }

  Future<void> _emptyStoreFunction() async {
    setState(
      () => _emptyingProgress = true,
    );
    await _store.manage.resetAsync();

    setState(
      () => _emptyingProgress = false,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Finished Emptying',
          ),
        ),
      );
    }

    _loadStatistics();
  }

  Future<void> _exportStoreFunction() async {
    setState(
      () => _exportingProgress = true,
    );
    final result = await _store.export.withGUI(context: context);

    setState(
      () => _exportingProgress = false,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result ? 'Exported Sucessfully' : 'Export Cancelled',
          ),
        ),
      );
    }
  }

  Future<void> _useStoreFunction() async {
    context.read<GeneralBloc>().add(
          CurrentStoreSet(
            widget.storeName,
          ),
        );

    context.read<GeneralBloc>().resetMap();
    setState(() {});
  }

  IconButton deleteStoreButton({required bool isCurrentStore}) => IconButton(
        icon: _deletingProgress
            ? const CircularProgressIndicator(
                strokeWidth: 3,
              )
            : Icon(
                Icons.delete_forever,
                color: isCurrentStore ? null : Colors.red,
              ),
        tooltip: 'Delete Store',
        onPressed: isCurrentStore || _deletingProgress
            ? null
            : () async {
                setState(() {
                  _deletingProgress = true;
                  _emptyingProgress = true;
                });
                await _store.manage.deleteAsync();
              },
      );

  @override
  Widget build(BuildContext context) => BlocBuilder<GeneralBloc, GeneralState>(
        builder: (context, state) {
          final isCurrentStore = state.currentStore == widget.storeName;

          return FutureBuilder<bool>(
            future: _store.manage.readyAsync,
            builder: (context, ready) => ExpansionTile(
              title: Text(
                widget.storeName,
                style: TextStyle(
                  fontWeight:
                      isCurrentStore ? FontWeight.bold : FontWeight.normal,
                  color: ready.data == false ? Colors.red : null,
                ),
              ),
              subtitle: _deletingProgress ? const Text('Deleting...') : null,
              leading: ready.data == false
                  ? const Icon(
                      Icons.error,
                      color: Colors.red,
                    )
                  : null,
              onExpansionChanged: (e) {
                if (e) _loadStatistics();
              },
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder<Image?>(
                      future: _image,
                      builder: (context, snapshot) => snapshot.data == null
                          ? const SizedBox(
                              height: 125,
                              width: 125,
                              child: Icon(Icons.help_outline, size: 36),
                            )
                          : snapshot.data!,
                    ),
                    Column(
                      children: cachingHelper.stats(
                        tiles: _tiles,
                        size: _size,
                        cacheHits: _cacheHits,
                        cacheMisses: _cacheMisses,
                        image: _image,
                        store: _store,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 10),
                    child: ready.data ?? false
                        ? Column(
                            children: [
                              const SizedBox(height: 15),
                              _storeTileIconButton(isCurrentStore),
                            ],
                          )
                        : InvalidStore(
                            widget: deleteStoreButton(
                              isCurrentStore: isCurrentStore,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  Row _storeTileIconButton(bool isCurrentStore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        deleteStoreButton(
          isCurrentStore: isCurrentStore,
        ),
        IconButton(
          icon: _emptyingProgress
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                )
              : const Icon(Icons.delete),
          tooltip: 'Empty Store',
          onPressed: _emptyingProgress ? null : _emptyStoreFunction,
        ),
        IconButton(
          icon: _exportingProgress
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                )
              : const Icon(
                  Icons.upload_file_rounded,
                ),
          tooltip: 'Export Store',
          onPressed: _exportingProgress ? null : _exportStoreFunction,
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: 'Edit Store',
          onPressed: () => goRouter.pushNamed(
            'storeEditorPopup',
            extra: {
              'existingStoreName': null,
              'isStoreInUse': false,
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Force Refresh Statistics',
          onPressed: () => _loadStatistics(
            withoutCachedStatistics: true,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.done,
            color: isCurrentStore ? Colors.green : null,
          ),
          tooltip: 'Use Store',
          onPressed: isCurrentStore ? null : _useStoreFunction,
        ),
      ],
    );
  }
}
