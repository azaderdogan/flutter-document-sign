import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../repositories/base_auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final BaseAuthRepository _authRepository;
  AuthenticationBloc(this._authRepository)
      : super(AuthenticationStateInitial()) {
    on<AuthenticationEvent>((event, emit) {});
    on<AuthenticationEventLoginWithGoogle>(_onLoginWithGoogle);
  }

  Future<FutureOr<void>> _onLoginWithGoogle(
      AuthenticationEventLoginWithGoogle event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationStateLoading());
      var result = await _authRepository.signInWithGoogle();
      if (result != null) {
        emit(AuthenticationStateLogin());
      } else {
        emit(AuthenticationStateInitial());
      }
    } on FirebaseException catch (e) {
      emit(AuthenticationStateError(e.message ?? ''));
    } catch (e) {
      emit(AuthenticationStateError(e.toString()));
    }
  }
}
