part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateLogin extends AuthenticationState {}

class AuthenticationStateLogout extends AuthenticationState {}

class AuthenticationStateLoading extends AuthenticationState {}

class AuthenticationStateError extends AuthenticationState {
  final String message;
  AuthenticationStateError(this.message);
}
