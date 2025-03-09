part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginProcess extends LoginState {}

final class LoginCompleted extends LoginState {}

final class LoginError extends LoginState {
  final String e;

  LoginError(this.e);
}
