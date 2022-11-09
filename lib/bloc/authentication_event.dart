part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationEventLoginWithGoogle extends AuthenticationEvent {}
