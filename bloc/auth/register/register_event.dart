part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class RegisterButtonPressed extends RegisterEvent {
  final String? email;
  final String? password;

  RegisterButtonPressed({required this.email, required this.password});
}
