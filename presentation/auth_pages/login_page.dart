import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../bloc/auth/login/login_bloc.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.e),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // email field
                  TextFormField(
                    controller: _emailController,
                    enabled: (state is! LoginProcess),
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      /// Makes this field required
                      FormBuilderValidators.required(),

                      /// this field must be an email
                      FormBuilderValidators.email(),
                    ]),
                  ),

                  // password field
                  TextFormField(
                    controller: _passwordController,
                    enabled: (state is! LoginProcess),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      /// Makes this field required
                      FormBuilderValidators.required(),

                      /// this field must be a password
                      FormBuilderValidators.password(),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // login button
                  ElevatedButton(
                    onPressed: () {
                      // check if login is in processing do nothing
                      if (state is LoginProcess) return;

                      // check if form is valid
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // close keyboard
                      FocusScope.of(context).unfocus();

                      // call login bloc
                      context.read<LoginBloc>().add(
                        LoginButtonPressed(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    child:
                        state is LoginProcess
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                            : const Text('Login'),
                  ),
                  const SizedBox(height: 16),

                  // sign up button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const RegisterPage();
                          },
                        ),
                      );
                    },
                    child: const Text('Don\'t have an account? Sign up'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
