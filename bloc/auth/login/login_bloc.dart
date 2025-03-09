import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../repositories/auth/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // get an instance of auth service
  final AuthService _authService = AuthService();

  LoginBloc() : super(LoginInitial()) {
    // login button pressed event
    on<LoginButtonPressed>((event, emit) async {
      // set login to process for showing loading
      emit(LoginProcess());

      // check email and password not empty
      //todo: check email construction and password strong level
      if (event.email == null || event.email!.isEmpty) {
        emit(LoginError('Email must not be EMPTY!'));
        return;
      }
      if (event.password == null || event.password!.isEmpty) {
        emit(LoginError('Password must not be EMPTY!'));
        return;
      }

      // call sign in method
      try {
        AuthResponse response = await _authService.signInWithEmailPassword(
          event.email!,
          event.password!,
        );

        // set bloc state to login success
        emit(LoginCompleted());
      }
      // catch any errors
      catch (e) {
        // check if error is AuthException
        if (e is AuthException) {
          print(e.message);
          emit(LoginError(e.message));
          return;
        }
        print(e);
        // throw any error happened
        emit(LoginError(e.toString()));
      }
    });
  }
}
