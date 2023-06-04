import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:real_estate_app/router/router.gr.dart';
import 'package:real_estate_app/utils/snack_bar.dart';

import '../../../services/firebase_auth_methods.dart';
import '../widget/text_input.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login-email-password';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void loginUser() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      context
          .read<FirebsaeAuthMethods>()
          .loginWithEmail(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          )
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset('assets/logo.svg',
                    width: 350.w), // Your Logo goes here
                const SizedBox(height: 10),
                TextInput(
                  hideInput: false,
                  hint: 'Enter your email',
                  textEditingController: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // You might want to add more comprehensive email validation
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextInput(
                  hideInput: true,
                  hint: 'Enter your password',
                  textEditingController: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // You might want to add more password validation (length, complexity, etc.)
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: loginUser,
                  child: const Text(
                    "Login",
                  ),
                ),
                SizedBox(height: 20.h),
                SignInButton(
                  Buttons.Google,
                  onPressed: () {/* Google Sign-In action */},
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    context.router.push(const SignUpRoute());
                  },
                  child: const Text(
                    "or, Sign Up",
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
