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
  const AuthInitialLoginFailure(this.errorType);

  final SimpleLoginResultType errorType;

  @override
  List<Object?> get props => [];
}
