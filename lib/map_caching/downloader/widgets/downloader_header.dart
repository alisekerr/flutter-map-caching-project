import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_maps/main_map/main_map.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:flutter_maps/map_caching/downloader/widgets/min_max_zoom_controller_popup.dart';
import 'package:flutter_maps/map_caching/downloader/widgets/shape_controller_popup.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloaderHeader extends StatelessWidget {
  const DownloaderHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Downloader',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            BlocBuilder<GeneralBloc, GeneralState>(
              builder: (context, state) => state.currentStore == null
                  ? const SizedBox.shrink()
                  : const Text(
                      'Existing tiles will appear in red',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) => const MinMaxZoomControllerPopup(),
            ).then(
              (_) => context.read<MapBloc>().triggerManualPolygonRecalc(),
            );
          },
          icon: const Icon(Icons.zoom_in),
        ),
        IconButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (_) => const ShapeControllerPopup(),
          ).then(
            (_) => context.read<MapBloc>().triggerManualPolygonRecalc(),
          ),
          icon: const Icon(Icons.select_all),
        ),
      ],
    );
  }
}
