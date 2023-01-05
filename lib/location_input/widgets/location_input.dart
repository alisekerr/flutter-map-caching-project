import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/l10n/l10n.dart';
import 'package:flutter_maps/location_input/location_input.dart';
import 'package:flutter_maps/theme/theme.dart';
import 'package:locations_repository/locations_repository.dart';

class LocationInput extends StatelessWidget {
  const LocationInput({
    super.key,
    required this.onSelected,
  });

  final void Function(Location) onSelected;

  static const _inputBorderRadius = 25.0;
  static const _mainMargin = 12.0;

  @override
  Widget build(BuildContext context) {
    final _locationInputService = LocationInputService(
      locationsRepository: context.read<LocationsRepository>(),
    );
    return Autocomplete<Location>(
      displayStringForOption: (option) => option.label,
      optionsBuilder: (textEditingValue) async {
        final _options = await _locationInputService.getSuggestions(
          textEditingValue.text,
        );
        return _options;
      },
      fieldViewBuilder: _textField,
      onSelected: onSelected,
      optionsViewBuilder: _optionsViewBuilder,
    );
  }

  Widget _textField(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    void Function() onFieldSubmitted,
  ) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _mainMargin,
      ),
      child: TextField(
        controller: textEditingController,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors().darkColor,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const IconButton(
            icon: Icon(
              Icons.location_on,
              color: AppColors.white,
            ),
            onPressed: null,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppColors.white,
            ),
            onPressed: () {
              textEditingController.clear();
            },
          ),
          hintText: l10n.findLocation,
          hintStyle: Theme.of(context).textTheme.headline5,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              _inputBorderRadius,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              _inputBorderRadius,
            ),
          ),
        ),
      ),
    );
  }

  Widget _optionsViewBuilder(
    BuildContext context,
    void Function(Location) onSelected,
    Iterable<Location> options,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    const itemHeight = 80.0;

    final listHeight = 0.5 * screenHeight ~/ itemHeight * itemHeight;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _inputBorderRadius + _mainMargin,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: listHeight),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);

                return SizedBox(
                  height: itemHeight,
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            onSelected(option);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: ListTile(
                            minVerticalPadding: 0,
                            title: Text(
                              option.name,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            subtitle: Text(
                              option.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
