// ignore_for_file: directives_ordering

// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tat_core/tat_core.dart';

// 🌎 Project imports:
import 'package:tat/data/storage_manager.dart';
import 'package:tat/utils/debug_log.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required StorageManager storage,
    required SimpleLoginUseCase simpleLoginUseCase,
  })  : _storage = storage,
        _simpleLoginUseCase = simpleLoginUseCase,
        super(AuthLoading()) {
    on<AuthInitialLoginCalled>((event, emit) async {
      _log('bloc event triggered.', areaName: (AuthInitialLoginCalled).toString());

      emit(AuthLoading());
      final loginResult = await _initialLogin(event.credential);

      if (loginResult.isSuccess) {
        await _saveCredential(event.credential);
        emit(AuthInitialLoginSuccess());
        return;
      }

      emit(AuthInitialLoginFailure(loginResult.resultType));
    });

    on<AuthLogoutCalled>((event, emit) {
      emit(AuthLoading());
    });
  }

  final StorageManager _storage;
  final SimpleLoginUseCase _simpleLoginUseCase;

  @override
  void onError(Object error, StackTrace stackTrace) {
    _log('Error in bloc', areaName: 'onError', error: error, stackTrace: stackTrace);
    super.onError(error, stackTrace);
  }

  Future<SimpleLoginResult> _initialLogin(LoginCredential credential) async =>
      _simpleLoginUseCase(credential: credential);

  Future<void> _saveCredential(LoginCredential credential) async {
    await _storage.setData(key: StorageKeys.keyUserId, value: credential.userId);
    await _storage.setData(key: StorageKeys.keyPassword, value: credential.password, isSecure: true);
  }
}

void _log(Object object, {required String areaName, Object? error, StackTrace? stackTrace}) => debugLog(
      object,
      name: '${(AuthBloc).toString()} $areaName',
      error: error,
      stackTrace: stackTrace,
    );
