import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bloc/auth/register/register_bloc.dart';
import 'repositories/auth/auth_gate.dart';
import 'core/service_locator.dart';
import 'bloc/auth/login/login_bloc.dart';

void main() async {
  // get it setup locator define here
  setupLocator();

  // supabase database initializing  define here
  await Supabase.initialize(
    url: 'Your supabase project url',
    anonKey: 'your supabase project anon key',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<LoginBloc>()),
        BlocProvider(create: (_) => GetIt.instance<RegisterBloc>()),
      ],
      child: MaterialApp(
        title: 'Supabase Flutter',
        debugShowCheckedModeBanner: false,
        supportedLocales: [Locale('en'), Locale('fa')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
