import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/common_widgets/rounded_small_button.dart';
import 'package:flutter_twitter_app/core/constants/ui_constants.dart';
import 'package:flutter_twitter_app/core/theme/pallete.dart';
import 'package:flutter_twitter_app/features/auth/widgets/auth_field.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // textfield 1
                AuthField(
                  controller: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 25),
                AuthField(
                  controller: passwordController,
                  hintText: 'Password',
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    onTap: onLogin,
                    label: 'Done',
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign up',
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
