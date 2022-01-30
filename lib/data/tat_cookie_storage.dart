// 📦 Package imports:
import 'package:cookie_jar/cookie_jar.dart';

// 🌎 Project imports:
import 'package:tat/data/storage_manager.dart';

class TATCookieStorage implements Storage {
  TATCookieStorage({required StorageManager storageManager}) : _storageManager = storageManager;

  final StorageManager _storageManager;
  bool? _persistSession, _ignoreExpires;

  String get _keyNamePrefix {
    assert(_persistSession != null, '_persistSession must not be null');
    assert(_ignoreExpires != null, '_ignoreExpires must not be null');

    return 'cookies_ie${(_ignoreExpires ?? false) ? 1 : 0}_ps${(_persistSession ?? false) ? 1 : 0}';
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    _persistSession = persistSession;
    _ignoreExpires = ignoreExpires;
  }

  @override
  Future<String?> read(String key) => _storageManager.getData<String>(key: '$_keyNamePrefix$key', isSecure: true);

  @override
  Future<void> write(String key, String value) async => _storageManager.setData(
        key: '$_keyNamePrefix$key',
        value: value,
        isSecure: true,
      );

  @override
  Future<void> delete(String key) async => _storageManager.removeData(key: '$_keyNamePrefix$key', isSecure: true);

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final key in keys) {
      await delete(key);
    }
  }
}
