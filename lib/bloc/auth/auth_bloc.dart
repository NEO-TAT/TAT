// ignore_for_file: directives_ordering

// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tat_core/tat_core.dart';

// 🌎 Project imports:
import 'package:tat/data/storage_manager.dart';

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
      emit(AuthLoading());
      await _initialLogin(event.credential);

      // TODO(TU): if success ...
      await _saveCredential(event.credential);
    });

    on<AuthLogoutCalled>((event, emit) {
      emit(AuthLoading());
    });
  }

  final StorageManager _storage;
  final SimpleLoginUseCase _simpleLoginUseCase;

  Future<void> _initialLogin(LoginCredential credential) async {
    await _simpleLoginUseCase(credential: credential);
  }

  Future<void> _saveCredential(LoginCredential credential) async {
    await _storage.setData(key: StorageKeys.keyUserId, value: credential.userId);
    await _storage.setData(key: StorageKeys.keyPassword, value: credential.password, isSecure: true);
  }
}
