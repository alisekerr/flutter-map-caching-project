import 'dart:math';

import 'package:intl/intl.dart';

extension SizeFormatter on num {
  String get asReadableSize {
    if (this <= 0) return '0 B';
    final units = <String>['B', 'KiB', 'MiB', 'GiB', 'TiB'];
    final digitGroups = log(this) ~/ log(1024);
    // ignore: lines_longer_than_80_chars
    return '${NumberFormat('#,##0.#').format(this / pow(1024, digitGroups))} ${units[digitGroups]}';
  }
}
