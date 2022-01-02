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
  bool secure = false,
}) {
  if (!kDebugMode) return;
  final msg = debugTarget.toString();
  log(
    secure ? _createSecureDebugMsg(msg) : msg,
    time: time,
    sequenceNumber: sequenceNumber,
    level: level.value,
    name: '${Strings.debugFlagTAT} $name',
    zone: zone,
    error: error,
    stackTrace: stackTrace,
  );
}

String _createSecureDebugMsg(String originMsg) {
  const maskChar = '*';
  return '🔒 ${maskChar * originMsg.length}';
}
