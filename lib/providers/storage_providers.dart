// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:tat/data/local_storage/local_storage.dart';
import 'package:tat/data/local_storage/tat_storage.dart';
import 'package:tat/data/tat_cookie_storage.dart';

final storageManagerProvider = Provider<LocalStorage>((_) => TATStorage());

final tatCookieStorageProvider = Provider(
  (ref) => TATCookieStorage(storage: ref.watch(storageManagerProvider)),
);
