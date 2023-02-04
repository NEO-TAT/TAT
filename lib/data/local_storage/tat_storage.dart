// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'package:tat/data/local_storage/local_storage.dart';
import 'package:tat/strings.dart';
import 'package:tat/utils/debug_log.dart';

/// The storage of TAT app provides efficient read/write performance and can encrypt data.
@immutable
class TATStorage implements LocalStorage {
  factory TATStorage() {
    if (!_instance._isInitialized) {
      const secureStorage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
      );
      _instance.secureStorage = secureStorage;
    }
    return _instance;
  }

  TATStorage._()
      : _encryptedDataKeys = {},
        _encryptionKey = [];

  static final _instance = TATStorage._();

  final List<int> _encryptionKey;
  final Set<String> _encryptedDataKeys;
  late final FlutterSecureStorage secureStorage;
  late final _StorageBoxes _boxes;

  bool get _isInitialized => _encryptionKey.isNotEmpty;

  /// An initialization process which should be called at first
  /// to ensure the encrypted Key has been loaded,
  /// and open all hive boxes.
  Future<void> init() async {
    final hasEncryptionKey = await secureStorage.containsKey(key: Strings.appEncryptionKey);
    final encryptionKey = hasEncryptionKey
        ? (await secureStorage.read(key: Strings.appEncryptionKey) ?? base64Encode(Hive.generateSecureKey()))
        : base64Encode(Hive.generateSecureKey());

    if (!hasEncryptionKey) await secureStorage.write(key: Strings.appEncryptionKey, value: encryptionKey);

    _encryptionKey.addAll(base64Decode(encryptionKey));

    _boxes = _StorageBoxes(
      intBox: await _openBox<int>(),
      doubleBox: await _openBox<double>(),
      stringBox: await _openBox<String>(),
      boolBox: await _openBox<bool>(),
      runesBox: await _openBox<Runes>(),
      symbolBox: await _openBox<Symbol>(),
      secureBox: await _openBox<String>(encryptionCipher: HiveAesCipher(_encryptionKey)),
    );
    _debugCheckIfBoxesOpened();

    _log('TATStorage($hashCode) initialized.', areaName: 'init');
  }

  Future<Box<T>> _openBox<T extends Object>({
    HiveCipher? encryptionCipher,
  }) =>
      Hive.openBox<T>(
        (T).toString(),
        encryptionCipher: encryptionCipher,
      );

  void _debugCheckIfBoxesOpened() {
    assert(_boxes.of<int>().isOpen, 'intBox is not open!');
    assert(_boxes.of<double>().isOpen, 'doubleBox is not open!');
    assert(_boxes.of<String>().isOpen, 'stringBox is not open!');
    assert(_boxes.of<bool>().isOpen, 'boolBox is not open!');
    assert(_boxes.of<Runes>().isOpen, 'runesBox is not open!');
    assert(_boxes.of<Symbol>().isOpen, 'symbolBox is not open!');
    assert(_boxes.secureBox.isOpen, 'secureBox is not open!');
  }

  Future<bool> _setSecureData(String key, String value) async {
    await _boxes.secureBox.put(key, value);

    _log('key: $key', areaName: '_setSecureData');
    _log(value, areaName: '_setSecureData', secure: true);

    final ok = _boxes.secureBox.containsKey(key);
    if (ok) _encryptedDataKeys.add(key);
    return ok;
  }

  bool _putNonSecureDataToBox<T extends Object>(Box<T> box, String key, T data) {
    box.put(key, data);

    _log('key: $key', areaName: '_setData');
    _log('value: $data', areaName: '_setData');

    return box.containsKey(key);
  }

  bool _setData<T extends Object>(String key, T value) => _putNonSecureDataToBox(_boxes.of<T>(), key, value);

  String? _getSecureData(String key) => _boxes.secureBox.get(key);

  Object? _getData<T extends Object>(String key) => _boxes.of<T>().get(key);

  Future<bool> _removeSecureData(String key) async {
    await _boxes.secureBox.delete(key);
    final ok = !_boxes.secureBox.containsKey(key);
    if (ok) _encryptedDataKeys.remove(key);
    return ok;
  }

  Future<bool> _removeData<T extends Object>(String key) async {
    final box = _boxes.of<T>();
    await box.delete(key);
    return !box.containsKey(key);
  }

  @override
  Future<bool> setData<T extends Object>({
    required String key,
    required T value,
    bool isSecure = false,
  }) async {
    if (!_isInitialized) await init();
    if (isSecure && T != String) throw Exception('Value set to secure storage should always String, can not be $T.');
    return isSecure ? await _setSecureData(key, value as String) : _setData<T>(key, value);
  }

  @override
  Future<T?> getData<T extends Object>({required String key}) async {
    if (!_isInitialized) await init();
    _log('key: $key', areaName: 'getData');
    return (_encryptedDataKeys.contains(key) ? _getSecureData(key) : _getData<T>(key)) as T?;
  }

  @override
  Future<bool> removeData<T extends Object>({required String key}) async {
    if (!_isInitialized) await init();
    _log('key: $key', areaName: 'removeData');
    return _encryptedDataKeys.contains(key) ? _removeSecureData(key) : _removeData<T>(key);
  }

  @override
  Future<void> dispose() => _boxes.dispose();
}

@immutable
class _StorageBoxes {
  const _StorageBoxes({
    required Box<int> intBox,
    required Box<double> doubleBox,
    required Box<String> stringBox,
    required Box<bool> boolBox,
    required Box<Runes> runesBox,
    required Box<Symbol> symbolBox,
    required this.secureBox,
  })  : _intBox = intBox,
        _doubleBox = doubleBox,
        _stringBox = stringBox,
        _boolBox = boolBox,
        _runesBox = runesBox,
        _symbolBox = symbolBox;

  final Box<int> _intBox;
  final Box<double> _doubleBox;
  final Box<String> _stringBox;
  final Box<bool> _boolBox;
  final Box<Runes> _runesBox;
  final Box<Symbol> _symbolBox;
  final Box<String> secureBox;

  Box<Object> of<T extends Object>() {
    switch (T) {
      case int:
        return _intBox;
      case double:
        return _doubleBox;
      case String:
        return _stringBox;
      case bool:
        return _boolBox;
      case Runes:
        return _runesBox;
      case Symbol:
        return _symbolBox;
      default:
        throw Exception('not support the box type: $T');
    }
  }

  Future<void> _doAsyncOperationsToAllBoxes(Future<void> Function(Box<dynamic> box) operation) async {
    final allBoxes = [_intBox, _doubleBox, _stringBox, _boolBox, _runesBox, _symbolBox];
    for (final box in allBoxes) {
      await operation(box);
    }
  }

  Future<void> _updateAllToDisk() => _doAsyncOperationsToAllBoxes((box) => box.flush());

  Future<void> _compactAll() => _doAsyncOperationsToAllBoxes((box) => box.compact());

  Future<void> _closeAll() => _doAsyncOperationsToAllBoxes((box) => box.close());

  Future<void> dispose() async {
    await _updateAllToDisk();
    await _compactAll();
    await _closeAll();
  }
}

void _log(Object object, {required String areaName, bool? secure}) => debugLog(
      object,
      secure: secure ?? false,
      name: 'TATStorage $areaName',
    );
