// 📦 Package imports:
import 'package:meta/meta.dart';

/// [LocalStorage] is an interface that actually stores data on the device
/// so that it can be used again after the app is closed and reopened.
///
/// It provides all CRUD operations: [setData], [getData], [removeData].
///
/// You can choose to store the data directly,
/// or store it encrypted such as cookies or passwords, etc.
/// Defaults are stored unencrypted.
@immutable
abstract class LocalStorage {
  /// Put the non-null [value] (which is [T] type) to the [key] location,
  /// or modify the [key]'s data to [value] in storage.
  ///
  /// If the [key] already has corresponding data, it will be overwritten.
  /// The old [value] type [T] can be different from the new [T], This does not affect the set and query of data.
  ///
  /// [isSecure] should be set to `true` if encrypted stored data is required, default is `false`.
  /// When [isSecure] is set to `true`, the type [T] of [value] should always be `String`.
  ///
  /// After the operation is completed, a Boolean value will be returned,
  /// indicating whether the [value] of [key] has been successfully added or modified.
  ///
  /// Setting [value] to `null` and removing data are different behaviors, which is not allowed,
  /// To remove data, use [removeData].
  Future<bool> setData<T extends Object>({
    required String key,
    required T value,
    bool isSecure = false,
  });

  /// Get the data corresponding to the [key] from storage.
  ///
  /// If the data to be obtained is of a specific type [T],
  /// please provide the type [T] to change the type of the returned value.
  ///
  /// If the data corresponding to the [key] cannot be regarded as type [T], a run-time exception may occur.
  ///
  /// If the [key] does not exist in storage, `null` will be returned,
  /// So no matter what type [T] is, the returned value may be `null`.
  /// You have to additionally handle the null case.
  Future<T?> getData<T extends Object>({required String key});

  /// Remove the data corresponding to [key] and [key] from storage.
  ///
  /// If the [key]'s data is not corresponded to type [T],
  /// then this operation will be canceled, and `false` will returned.
  ///
  /// After the operation is completed, a Boolean value will be returned,
  /// indicating whether the data of [key] and [key] has been successfully removed,
  /// if the [key] is not existed in the storage, `false` will be returned.
  Future<bool> removeData<T extends Object>({required String key});
}
