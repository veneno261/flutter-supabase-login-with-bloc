import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../bloc/auth/register/register_bloc.dart';
import '../../repositories/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // get auth service
  final authService = AuthService();

  // form key to check fields validations
  final _formKey = GlobalKey<FormState>();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // sign up button pressed
  void register() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // check if form not completed correctly show error
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // check if passwords do not matched show error
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // call sign up bloc
    context.read<RegisterBloc>().add(
      RegisterButtonPressed(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          // if error happen when submit form show error
          if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.e),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          // show snack bar when register completed
          if (state is RegisterCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Register Completed, Please Confirm Your Email!'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 30),
              ),
            );

            // back to login page and clear
            Navigator.of(context).pop();
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
                    enabled: (state is! RegisterProcess),
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      /// this field is required
                      FormBuilderValidators.required(),

                      /// this field must be an email
                      FormBuilderValidators.email(),
                    ]),
                  ),

                  // password field
                  TextFormField(
                    controller: _passwordController,
                    enabled: (state is! RegisterProcess),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      /// this field is required
                      FormBuilderValidators.required(),

                      /// this field must have password conditions
                      FormBuilderValidators.password(
                        minLength: 8,
                        checkNullOrEmpty: true,
                        minUppercaseCount: 2,
                        minSpecialCharCount: 1,
                        minNumberCount: 2,
                        errorText:
                            "Min: Length 8, Upper Case 2, Num 2, Special Char 1",
                      ),
                    ]),
                  ),

                  // confirm password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    enabled: (state is! RegisterProcess),
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      /// this field is required
                      FormBuilderValidators.required(),

                      /// this func check passwords match when user typing
                      (val) {
                        if (val != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      },
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // sign up button
                  ElevatedButton(
                    onPressed: () {
                      // check if register is in processing do nothing
                      if (state is RegisterProcess) return;

                      // close keyboard
                      FocusScope.of(context).unfocus();

                      // call register method and check fields
                      register();
                    },
                    child:
                        state is RegisterProcess
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                            : const Text('Register'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
