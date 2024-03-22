import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/widgest/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgest/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sign Up.',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            AuthField(
              hintText: 'Name',
              controller: nameController,
            ),
            const SizedBox(height: 15),
            AuthField(hintText: 'Email', controller: emailController),
            const SizedBox(height: 15),
            AuthField(
              hintText: 'Password',
              controller: passwordController,
              isObscureText: true,
            ),
            const SizedBox(height: 20),
            const AuthGradientButton(),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text: 'Don\'t have an acccount? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                        text: 'Sign In',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold))
                  ]),
            )
          ],
        ),
      ),
    ));
  }
}