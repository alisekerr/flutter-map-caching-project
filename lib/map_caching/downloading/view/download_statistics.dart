import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_maps/map_caching/downloading/widgets/downloading_stat_display.dart';
import 'package:flutter_maps/vars/size_formatter.dart';

class DownloadStatistics extends StatelessWidget {
  const DownloadStatistics({
    super.key,
    required this.data,
  });

  final DownloadProgress data;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DownloadingStatDisplay(
                statistic:
                    '${data.successfulTiles} / ${data.maxTiles} (${data.averageTPS.round()} avg tps)',
                description: 'successful / total tiles',
              ),
              const SizedBox(height: 2),
              DownloadingStatDisplay(
                statistic: (data.successfulSize * 1024).asReadableSize,
                description: 'downloaded size',
              ),
              const SizedBox(height: 2),
              DownloadingStatDisplay(
                statistic:
                    data.duration.toString().split('.').first.padLeft(8, '0'),
                description: 'duration taken',
              ),
              const SizedBox(height: 2),
              DownloadingStatDisplay(
                statistic: data.estRemainingDuration
                    .toString()
                    .split('.')
                    .first
                    .padLeft(8, '0'),
                description: 'est remaining duration',
              ),
              const SizedBox(height: 2),
              DownloadingStatDisplay(
                statistic: data.estTotalDuration
                    .toString()
                    .split('.')
                    .first
                    .padLeft(8, '0'),
                description: 'est total duration',
              ),
              const SizedBox(height: 2),
              DownloadingStatDisplay(
                statistic:
                    '${data.existingTiles} (${data.existingTilesDiscount.ceil()}%) | ${data.seaTiles} (${data.seaTilesDiscount.ceil()}%)',
                description: 'existing tiles | sea tiles',
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: data.percentageProgress / 100,
            minHeight: 8,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: data.failedTiles.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.report_off, size: 36),
                      SizedBox(height: 10),
                      Text('No Failed Tiles'),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.failedTiles.length.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'failed tiles',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.failedTiles.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(data.failedTiles[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      );
}
