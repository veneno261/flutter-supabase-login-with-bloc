import 'package:get_it/get_it.dart';
import 'package:profitflow/bloc/auth/register/register_bloc.dart';

import '../bloc/auth/login/login_bloc.dart';
import '../repositories/auth/auth_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register services here
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerFactory<LoginBloc>(() => LoginBloc());
  locator.registerFactory<RegisterBloc>(() => RegisterBloc());
}
