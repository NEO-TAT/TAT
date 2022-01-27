part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthNoAuth extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthInitialLoginSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthInitialLoginFailure extends AuthState {
  @override
  List<Object?> get props => [];
}
