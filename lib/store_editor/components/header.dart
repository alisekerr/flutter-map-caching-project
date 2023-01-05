import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/store_editor/store_editor.dart';

AppBar buildHeader({
  required StoreEditorPopup widget,
  required bool mounted,
  required GlobalKey<FormState> formKey,
  required Map<String, String> newValues,
  required bool useNewCacheModeValue,
  required String? cacheModeValue,
  required BuildContext context,
}) =>
    AppBar(
      title: Text(
        widget.existingStoreName == null
            ? 'Create New Store'
            : "Edit '${widget.existingStoreName}'",
      ),
      actions: [
        IconButton(
          icon: Icon(
            widget.existingStoreName == null ? Icons.save_as : Icons.save,
          ),
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saving...'),
                duration: Duration(milliseconds: 1500),
              ),
            );

            // Give the asynchronus validation a chance

            await Future<void>.delayed(const Duration(seconds: 1));
            if (!mounted) return;

            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              final newStoreName = newValues['storeName']!;

              final instance = widget.existingStoreName == null
                  ? FMTC.instance(newStoreName)
                  : await FMTC
                      .instance(widget.existingStoreName!)
                      .manage
                      .renameAsync(newStoreName);

              await instance.manage.createAsync();
              await instance.metadata.addAsync(
                key: 'sourceURL',
                value: newValues['sourceURL']!,
              );
              await instance.metadata.addAsync(
                key: 'validDuration',
                value: newValues['validDuration']!,
              );

              if (widget.existingStoreName == null || useNewCacheModeValue) {
                await instance.metadata.addAsync(
                  key: 'behaviour',
                  value: cacheModeValue ?? 'cacheFirst',
                );
              }

              if (!mounted) return;
              if (widget.isStoreInUse && widget.existingStoreName != null) {
                context.read<GeneralBloc>().add(CurrentStoreSet(newStoreName));
              }
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved successfully')),
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Please correct the appropriate fields',
                  ),
                ),
              );
            }
          },
        )
      ],
    );
