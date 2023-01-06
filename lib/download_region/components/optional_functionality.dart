import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/map/bloc/map_bloc.dart';

class OptionalFunctionality extends StatelessWidget {
  const OptionalFunctionality({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('OPTIONAL FUNCTIONALITY'),
          BlocBuilder<MapBloc, MapState>(
            builder: (context, state) => Column(
              children: [
                Row(
                  children: [
                    const Text('Only Download New Tiles'),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '`preventRedownload` within API. Controls whether the script will re-download tiles that already exist or not.',
                            ),
                            duration: Duration(seconds: 8),
                          ),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                    ),
                    Switch(
                      value: state.preventRedownload,
                      onChanged: (val) => context
                          .read<MapBloc>()
                          .add(PreventRedownloadSet(val)),
                      activeColor: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Remove Sea Tiles'),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '`seaTileRemoval` within API. Deletes tiles that are pure sea - tiles that match the tile at x=0, y=0, z=19 exactly. Note that this saves storage space, but not time or data: tiles still have to be downloaded to be matched. Not supported on satelite servers.',
                            ),
                            duration: Duration(seconds: 8),
                          ),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                    ),
                    Switch(
                      value: state.seaTileRemoval,
                      onChanged: (val) =>
                          context.read<MapBloc>().add(SeaTileRemovalSet(val)),
                      activeColor: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Disable Recovery'),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Disables automatic recovery. Use only for testing or in special circumstances.',
                            ),
                            duration: Duration(seconds: 8),
                          ),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                    ),
                    Switch(
                      value: state.disableRecovery,
                      onChanged: (val) async {
                        if (val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'This option is not recommended, use with caution',
                              ),
                              duration: Duration(seconds: 8),
                            ),
                          );
                        }
                        context.read<MapBloc>().add(DisableRecoverySet(val));
                      },
                      activeColor: Colors.amber,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
