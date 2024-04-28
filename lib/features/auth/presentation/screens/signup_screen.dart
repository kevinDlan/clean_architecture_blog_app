import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/screens/login_screen.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field_widget.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blog/presentation/screens/blog_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const SignupScreen());

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackbar(context, state.message, Colors.red);
            return;
          } else if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogScreen.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up.',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AuthFieldWidget(
                    hintText: "Name",
                    controller: nameController,
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
                        context.read<AuthBloc>().add(AuthSignUp(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      }
                    },
                    label: "Sign Up",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, LoginScreen.route());
                      },
                      child: RichText(
                          text: TextSpan(
                              text: "Already have an account ?  ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                            TextSpan(
                                text: "Sign In",
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
            ),
          );
        },
      ),
    );
  }
}

// https://www.youtube.com/watch?v=ELFORM9fmss&t=410s
