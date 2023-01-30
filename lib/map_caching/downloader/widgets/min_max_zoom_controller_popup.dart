import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/main_map/main_map.dart';
import 'package:google_fonts/google_fonts.dart';

class MinMaxZoomControllerPopup extends StatelessWidget {
  const MinMaxZoomControllerPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
          bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Min/Max Zoom Levels',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.zoom_out),
                  label: Text('Minimum Zoom Level'),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) return 'Required';
                  if (int.parse(input) < 1) return 'Must be 1 or more';
                  if (int.parse(input) > state.maxZoom) {
                    return 'Must be less than maximum zoom';
                  }

                  return null;
                },
                onChanged: (input) {
                  if (input.isNotEmpty) {
                    context.read<MapBloc>().add(MinZoomSet(int.parse(input)));
                  }
                },
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _NumericalRangeFormatter(min: 1, max: 22),
                ],
                textInputAction: TextInputAction.next,
                initialValue: state.minZoom.toString(),
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.zoom_in),
                  label: Text('Maximum Zoom Level'),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) return 'Required';
                  if (int.parse(input) > 22) return 'Must be 22 or less';
                  if (int.parse(input) < state.minZoom) {
                    return 'Must be more than minimum zoom';
                  }

                  return null;
                },
                onChanged: (input) {
                  if (input.isNotEmpty) {
                    context.read<MapBloc>().add(MaxZoomSet(int.parse(input)));
                  }
                },
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _NumericalRangeFormatter(min: 1, max: 22),
                ],
                textInputAction: TextInputAction.done,
                initialValue: state.maxZoom.toString(),
              ),
            ],
          ),
        ),
      );
}

class _NumericalRangeFormatter extends TextInputFormatter {
  _NumericalRangeFormatter({
    required this.min,
    required this.max,
  });
  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      newValue.text == ''
          ? newValue
          : int.parse(newValue.text) < min
              ? TextEditingValue.empty.copyWith(text: min.toString())
              : int.parse(newValue.text) > max
                  ? TextEditingValue.empty.copyWith(text: max.toString())
                  : newValue;
}
