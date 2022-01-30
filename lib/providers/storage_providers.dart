// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🌎 Project imports:
import 'package:tat/data/storage_manager.dart';
import 'package:tat/data/tat_cookie_storage.dart';

const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: IOSAccessibility.unlocked_this_device),
);

final storageManagerProvider = FutureProvider(
  (_) async => StorageManager(
    sharedPreferences: await SharedPreferences.getInstance(),
    secureStorage: _secureStorage,
  ),
);

final tatCookieStorageProvider = FutureProvider(
  (ref) async => TATCookieStorage(storageManager: await ref.watch(storageManagerProvider.future)),
);
