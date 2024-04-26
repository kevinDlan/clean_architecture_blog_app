import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_pallete.dart';
import '../widgets/auth_field_widget.dart';
import '../widgets/auth_gradient_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const LoginScreen());

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.message, Colors.red);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In.',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthFieldWidget(
                      hintText: "Email", controller: emailController),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthFieldWidget(
                    hintText: "Password",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthGradientButtonWidget(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      }
                    },
                    label: "Sign In",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, SignupScreen.route());
                      },
                      child: RichText(
                          text: TextSpan(
                              text: "Don't have an account ?  ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                            TextSpan(
                                text: "Sign Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: AppPallete.gradient1,
                                        fontWeight: FontWeight.bold))
                          ])),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
