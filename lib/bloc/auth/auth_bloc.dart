// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tat_core/tat_core.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SimpleLoginUseCase simpleLoginUseCase,
  })  : _simpleLoginUseCase = simpleLoginUseCase,
        super(AuthLoading()) {
    on<AuthInitialLoginCalled>((event, emit) async {
      emit(AuthLoading());
      await _initialLogin(event.credential);
    });

    on<AuthLogoutCalled>((event, emit) {
      emit(AuthLoading());
    });
  }

  final SimpleLoginUseCase _simpleLoginUseCase;

  Future<void> _initialLogin(LoginCredential credential) async {
    await _simpleLoginUseCase(credential: credential);
  }
}
