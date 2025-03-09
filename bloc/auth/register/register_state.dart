part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterProcess extends RegisterState {}

final class RegisterCompleted extends RegisterState {}

final class RegisterError extends RegisterState {
  final String e;

  RegisterError(this.e);
}
