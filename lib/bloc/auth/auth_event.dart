part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthInitialLoginCalled extends AuthEvent {
  const AuthInitialLoginCalled(this.credential);

  final LoginCredential credential;

  @override
  List<Object?> get props => [credential];
}

class AuthLogoutCalled extends AuthEvent {
  const AuthLogoutCalled();

  @override
  List<Object?> get props => [];
}
