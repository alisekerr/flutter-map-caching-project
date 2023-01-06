import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/map/map.dart';
import 'package:flutter_maps/vars/region_mode.dart';

class ShapeControllerPopup extends StatelessWidget {
  const ShapeControllerPopup({super.key});

  static Map<String, List<dynamic>> regionShapes = {
    'Square': [
      Icons.crop_square_sharp,
      RegionMode.square,
    ].toList(),
    'Rectangle (Vertical)': [
      Icons.crop_portrait_sharp,
      RegionMode.rectangleVertical,
    ].toList(),
    'Rectangle (Horizontal)': [
      Icons.crop_landscape_sharp,
      RegionMode.rectangleHorizontal,
    ].toList(),
    'Circle': [
      Icons.circle_outlined,
      RegionMode.circle,
    ].toList(),
    'Line/Path': [
      Icons.timeline,
      null,
    ].toList(),
  };

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) => ListView.separated(
            itemCount: regionShapes.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final key = regionShapes.keys.toList()[i];
              final icon = regionShapes.values.toList()[i][0] as IconData;
              final mode = regionShapes.values.toList()[i][1] as RegionMode?;

              return ListTile(
                visualDensity: VisualDensity.compact,
                title: Text(key),
                subtitle: i == regionShapes.length - 1
                    ? const Text('Disabled in example application')
                    : null,
                leading: Icon(icon),
                trailing:
                    state.regionMode == mode ? const Icon(Icons.done) : null,
                onTap: i != regionShapes.length - 1
                    ? () {
                        /* DÜZENLENDİ */
                        print(mode);
                        print("----------");
                        context.read<MapBloc>().add(RegionModeSet(mode));
                        print(state.regionMode.toString());
                        Navigator.of(context).pop();
                      }
                    : null,
                enabled: i != regionShapes.length - 1,
              );
            },
            separatorBuilder: (context, i) =>
                i == regionShapes.length - 2 ? const Divider() : Container(),
          ),
        ),
      );
}
