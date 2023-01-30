// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/map_caching/store_editor/widgets/header.dart';
import 'package:flutter_maps/map_caching/stores/widgets/loading_indicator.dart';
import 'package:http/http.dart' as http;

import 'package:validators/validators.dart' as validators;

class StoreEditorPopup extends StatefulWidget {
  const StoreEditorPopup({
    super.key,
    required this.existingStoreName,
    required this.isStoreInUse,
  });

  final String? existingStoreName;
  final bool? isStoreInUse;

  @override
  State<StoreEditorPopup> createState() => _StoreEditorPopupState();
}

class _StoreEditorPopupState extends State<StoreEditorPopup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _newValues = {};

  String? _httpRequestFailed;
  bool _storeNameIsDuplicate = false;

  bool _useNewCacheModeValue = false;
  String? _cacheModeValue;

  late final ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Changes not saved')),
          );
          return true;
        },
        child: Scaffold(
          appBar: buildHeader(
            widget: widget,
            mounted: mounted,
            formKey: _formKey,
            newValues: _newValues,
            useNewCacheModeValue: _useNewCacheModeValue,
            cacheModeValue: _cacheModeValue,
            context: context,
          )
          /* AppBar(
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

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newStoreName = _newValues['storeName']!;

                    final instance = widget.existingStoreName == null
                        ? FMTC.instance(newStoreName)
                        : await FMTC
                            .instance(widget.existingStoreName!)
                            .manage
                            .renameAsync(newStoreName);

                    await instance.manage.createAsync();
                    await instance.metadata.addAsync(
                      key: 'sourceURL',
                      value: _newValues['sourceURL']!,
                    );
                    await instance.metadata.addAsync(
                      key: 'validDuration',
                      value: _newValues['validDuration']!,
                    );

                    if (widget.existingStoreName == null ||
                        _useNewCacheModeValue) {
                      await instance.metadata.addAsync(
                        key: 'behaviour',
                        value: _cacheModeValue ?? 'cacheFirst',
                      );
                    }

                    if (!mounted) return;
                    if (widget.isStoreInUse! &&
                        widget.existingStoreName != null) {
                      context
                          .read<GeneralBloc>()
                          .add(CurrentStoreSet(newStoreName));
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
          ),*/
          ,
          body: BlocBuilder<GeneralBloc, GeneralState>(
            builder: (context, provider) => Padding(
              padding: const EdgeInsets.all(12),
              child: FutureBuilder<Map<String, String>?>(
                future: widget.existingStoreName == null
                    ? Future.sync(() => {})
                    : FMTC
                        .instance(widget.existingStoreName!)
                        .metadata
                        .readAsync,
                builder: (context, metadata) {
                  if (!metadata.hasData || metadata.data == null) {
                    return const LoadingIndicator(
                      message:
                          'Loading Settings...\n\nSeeing this screen for a long time?\nThere may be a misconfiguration of the\nstore. Try disabling caching and deleting\n faulty stores.',
                    );
                  }
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Store Name',
                              helperText: 'Must be valid directory name',
                              prefixIcon: Icon(Icons.text_fields),
                              isDense: true,
                            ),
                            onChanged: (input) async {
                              _storeNameIsDuplicate = (await FMTC.instance
                                      .rootDirectory.stats.storesAvailableAsync)
                                  .contains(FMTC.instance(input));
                              setState(() {});
                            },
                            validator: (input) {
                              if (input == null || input.isEmpty) {
                                return 'Required';
                              }

                              final nameValidation = FMTC.instance.settings
                                  .filesystemFormFieldValidator(input);
                              if (nameValidation != null) {
                                return nameValidation;
                              }

                              return _storeNameIsDuplicate
                                  ? 'Store already exists'
                                  : null;
                            },
                            onSaved: (input) =>
                                _newValues['storeName'] = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
                            initialValue: widget.existingStoreName,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Map Source URL (protocol required)',
                              helperText:
                                  "Use '{x}', '{y}', '{z}' as placeholders. Omit subdomain.",
                              prefixIcon: Icon(Icons.link),
                              isDense: true,
                            ),
                            onChanged: (i) async {
                              _httpRequestFailed = await http
                                  .get(
                                Uri.parse(
                                  NetworkTileProvider().getTileUrl(
                                    Coords(1, 1)..z = 1,
                                    TileLayer(urlTemplate: i),
                                  ),
                                ),
                              )
                                  .then(
                                (res) => res.statusCode == 200
                                    ? null
                                    : 'HTTP Request Failed',
                                onError: (Object o, StackTrace s) {
                                  return 'HTTP Request Failed (StrackTrace $s - Object )';
                                },
                              );

                              setState(() {});
                            },
                            validator: (i) {
                              final input = i ?? '';

                              if (!validators.isURL(
                                input,
                                requireProtocol: true,
                              )) {
                                return 'Invalid URL';
                              }
                              if (!input.contains('{x}') ||
                                  !input.contains('{y}') ||
                                  !input.contains('{z}')) {
                                return 'Missing placeholder(s)';
                              }

                              return _httpRequestFailed;
                            },
                            onSaved: (input) =>
                                _newValues['sourceURL'] = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.url,
                            initialValue: metadata.data!.isEmpty
                                ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                                : metadata.data!['sourceURL'],
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Valid Cache Duration',
                              helperText: 'Use 0 days for infinite duration',
                              suffixText: 'days',
                              prefixIcon: Icon(Icons.timelapse),
                              isDense: true,
                            ),
                            validator: (input) {
                              if (input == null ||
                                  input.isEmpty ||
                                  int.parse(input) < 0) {
                                return 'Must be 0 or more';
                              }
                              return null;
                            },
                            onSaved: (input) =>
                                _newValues['validDuration'] = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue: metadata.data!.isEmpty
                                ? '14'
                                : metadata.data!['validDuration'],
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text('Cache Behaviour:'),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _useNewCacheModeValue
                                      ? _cacheModeValue!
                                      : metadata.data!.isEmpty
                                          ? 'cacheFirst'
                                          : metadata.data!['behaviour'],
                                  onChanged: (newVal) => setState(
                                    () {
                                      _cacheModeValue = newVal ?? 'cacheFirst';
                                      _useNewCacheModeValue = true;
                                    },
                                  ),
                                  items:
                                      ['cacheFirst', 'onlineFirst', 'cacheOnly']
                                          .map<DropdownMenuItem<String>>(
                                            (v) => DropdownMenuItem(
                                              value: v,
                                              child: Text(v),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}
