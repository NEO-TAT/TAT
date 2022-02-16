// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:tat/data/local_storage/tat_storage.dart';
import 'package:tat/data/tat_cookie_storage.dart';

const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: IOSAccessibility.unlocked_this_device),
);

final storageManagerProvider = FutureProvider(
  (_) async => TATStorage(
    secureStorage: secureStorage,
  ),
);

final tatCookieStorageProvider = FutureProvider(
  (ref) async => TATCookieStorage(storage: await ref.watch(storageManagerProvider.future)),
);
