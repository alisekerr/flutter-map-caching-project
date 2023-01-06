import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/map_caching/bloc/general_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    size: 35,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stores',
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    BlocBuilder<GeneralBloc, GeneralState>(
                      builder: (context, state) =>
                          context.read<GeneralBloc>().state.currentStore == ''
                              ? const Text('Caching Disabled')
                              : Text(
                                  'Current Store: ${state.currentStore}',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          BlocBuilder<GeneralBloc, GeneralState>(
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.cancel),
              tooltip: 'Disable Caching',
              onPressed: state.currentStore == ''
                  ? null
                  : () {
                      context
                          .read<GeneralBloc>()
                          .add(const CurrentStoreSet(''));
                      context.read<GeneralBloc>().resetMap();
                    },
            ),
          ),
        ],
      );
}
