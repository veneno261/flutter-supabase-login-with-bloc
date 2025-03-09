import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../repositories/auth/auth_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  // get an instance of auth service
  final AuthService _authService = AuthService();

  RegisterBloc() : super(RegisterInitial()) {
    // on register button pressed event
    on<RegisterButtonPressed>((event, emit) async {
      // set register to process for showing loading
      emit(RegisterProcess());

      // check email and password not empty
      //todo: check email construction and password strong level
      if (event.email == null || event.email!.isEmpty) {
        emit(RegisterError('Email must not be EMPTY!'));
        return;
      }
      if (event.password == null || event.password!.isEmpty) {
        emit(RegisterError('Password must not be EMPTY!'));
        return;
      }

      // call register method
      try {
        AuthResponse response = await _authService.signUpWithEmailPassword(
          event.email!,
          event.password!,
        );

        // set bloc state to Register success
        emit(RegisterCompleted());
      }
      // catch any errors
      catch (e) {
        // check if error is AuthException
        if (e is AuthException) {
          emit(RegisterError(e.message));
          return;
        }
        // throw any error happened
        emit(RegisterError(e.toString()));
      }
    });
  }
}
