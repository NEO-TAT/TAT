// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:logging/logging.dart';

// 🌎 Project imports:
import 'package:tat/strings.dart';

/// log the target when not in production mode.
///
/// The debugTarget will be converted to string using `toString()` method when logging.
void debugLog(
  Object debugTarget, {
  DateTime? time,
  int? sequenceNumber,
  Level level = Level.ALL,
  String name = Strings.empty,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) return;
  log(
    debugTarget.toString(),
    time: time,
    sequenceNumber: sequenceNumber,
    level: level.value,
    name: '${Strings.debugFlagTAT} $name',
    zone: zone,
    error: error,
    stackTrace: stackTrace,
  );
}
