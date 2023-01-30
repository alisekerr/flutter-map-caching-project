import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/main_map/bloc/map_bloc.dart';
import 'package:flutter_maps/router/app_router.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

class DownloadingHeader extends StatefulWidget {
  const DownloadingHeader({
    super.key,
  });

  @override
  State<DownloadingHeader> createState() => _DownloadingHeaderState();
}

class _DownloadingHeaderState extends State<DownloadingHeader> {
  bool cancelled = false;

  @override
  Widget build(BuildContext context) => BlocBuilder<MapBloc, MapState>(
        builder: (context, state) => Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Downloading',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Downloading To: ${state.selectedStore?.storeName ?? '<in test mode>'}',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: const Icon(Icons.cancel),
              tooltip: 'Cancel Download',
              onPressed: cancelled
                  ? null
                  : () async {
                      await FMTC
                          .instance(state.selectedStore!.storeName)
                          .download
                          .cancel();
                      setState(() => cancelled = true);
                      const Duration(seconds: 1);
                      goRouter.pop();
                    },
            ),
          ],
        ),
      );
}
