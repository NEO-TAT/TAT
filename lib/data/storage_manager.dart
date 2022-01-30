// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🌎 Project imports:
import 'package:tat/utils/debug_log.dart';

/// A storage management which provides normal & secure way to save data on the device.
/// The operating system of the device can only be AOS or iOS.
class StorageManager {
  const StorageManager({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
    AndroidOptions? secureStorageAOSOptions,
    IOSOptions? secureStorageIOSOptions,
  })  : _storage = sharedPreferences,
        _secureStorage = secureStorage,
        _secureStorageAOSOptions = secureStorageAOSOptions,
        _secureStorageIOSOptions = secureStorageIOSOptions;

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _storage;

  final AndroidOptions? _secureStorageAOSOptions;
  final IOSOptions? _secureStorageIOSOptions;

  Future<bool> _setSecureData({
    required String key,
    required String? value,
  }) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _secureStorageAOSOptions,
      iOptions: _secureStorageIOSOptions,
    );

    _log('key: $key', areaName: '_setSecureData');
    _log('$value', areaName: '_setSecureData', secure: true);

    // Only check if this key is existed in storage, if `value` is not null,
    // or not existed in storage, if `value` is null.
    return (value == null) ^
        await _secureStorage.containsKey(
          key: key,
          aOptions: _secureStorageAOSOptions,
          iOptions: _secureStorageIOSOptions,
        );
  }

  Future<bool> _setData<T>({
    required String key,
    required T value,
  }) {
    _log('key: $key', areaName: '_setData');
    _log('value: $value', areaName: '_setData');

    switch (T) {
      case int:
        return _storage.setInt(key, value as int);
      case double:
        return _storage.setDouble(key, value as double);
      case String:
        return _storage.setString(key, value as String);
      case List<String>:
        return _storage.setStringList(key, value as List<String>);
      case Null:
        return _storage.remove(key);
      case Object:
      default:
        return _storage.setString(key, '$value');
    }
  }

  Future<bool> setData<T extends dynamic>({
    required String key,
    required T value,
    bool isSecure = false,
  }) async {
    return isSecure
        ? _setSecureData(key: key, value: value is Object ? value.toString() : value)
        : _setData<T>(key: key, value: value);
  }

  Future<String?> _getSecureData({required String key}) {
    _log('key: $key', areaName: '_getSecureData');

    return _secureStorage.read(
        key: key,
        aOptions: _secureStorageAOSOptions,
        iOptions: _secureStorageIOSOptions,
      );
  }

  Object? _getData<T>({required String key}) {
    _log('key: $key', areaName: '_getData');

    if (!_storage.containsKey(key)) return null;

    switch (T) {
      case int:
        return _storage.getInt(key);
      case double:
        return _storage.getDouble(key);
      case String:
        return _storage.getString(key);
      case List<String>:
        return _storage.getStringList(key);
      case Null:
        return _storage.remove(key);
      case Object:
      default:
        return _storage.getString(key);
    }
  }

  Future<T?> getData<T extends dynamic>({
    required String key,
    bool isSecure = false,
  }) {
    return isSecure ? _getSecureData(key: key) : _getData<T>(key: key) as T;
  }

  Future<bool> removeData({
    required String key,
    bool isSecure = false,
  }) =>
      setData(key: key, value: null, isSecure: isSecure);


}

class StorageKeys {
  static const keyUserId = 'userId';
  static const keyPassword = 'password';
}

void _log(Object object, {required String areaName, bool? secure}) => debugLog(
      object,
      secure: secure ?? false,
      name: 'StorageManager $areaName',
    );
