import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';
import 'package:real_estate_app/utils/snack_bar.dart';

import '../../../utils/theme_provider.dart';
import '../widget/text_input.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? gender;
  bool isLoading = false;

  List<String> genders = ['Male', 'Female', 'Other'];

  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await context.read<FirebsaeAuthMethods>().signUpWithEmail(
        user: {
          'name': fullNameController.text,
          'email': emailController.text,
          'age': ageController.text,
          'gender': gender ?? 'Other',
          'phone': phoneController.text,
          'role': 'user',
        },
        password: passwordController.text,
        context: context,
      ).then((value) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'User created successfully');
        context.router.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.themeMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                themeMode == ThemeModeType.light
                    ? SvgPicture.asset('assets/logo.svg', width: 250.w)
                    : Image.asset('assets/logo.png', width: 250.w),
// Your Logo goes here
                Text("Sign Up",
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 10),
                TextInput(
                  hint: 'Enter your full name',
                  textEditingController: fullNameController,
                  hideInput: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    // You might want to add more comprehensive name validation
                    if (value.contains(RegExp(r'^[a-zA-Z ]+$')) == false) {
                      return 'Please enter a valid name';
                    }
                    if (value.length < 3) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                TextInput(
                  hint: 'Enter your email',
                  textEditingController: emailController,
                  hideInput: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    //email validation regex
                    if (value.contains(
                            RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')) ==
                        false) {
                      return 'Please enter a valid email';
                    }
                    // You might want to add more comprehensive email validation
                    return null;
                  },
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextInput(
                  hint: 'Enter your password',
                  textEditingController: passwordController,
                  hideInput: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 6 characters';
                    }
                    if (value.contains(RegExp(r'[A-Z]')) == false) {
                      return 'Password must contain at least one capital letter';
                    }
                    if (value.contains(RegExp(r'[0-9]')) == false) {
                      return 'Password must contain at least one number';
                    }
                    // You might want to add more password validation (length, complexity, etc.)
                    return null;
                  },
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextInput(
                  hint: 'Re-enter your password',
                  textEditingController: confirmPasswordController,
                  hideInput: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please re-enter your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextInput(
                  hint: 'Enter your age',
                  textEditingController: ageController,
                  hideInput: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    if (value.contains(RegExp(r'^[0-9]+$')) == false) {
                      return 'Please enter a valid age';
                    }
                    if (int.parse(value) < 18) {
                      return 'You must be at least 18 years old';
                    }
                    return null;
                  },
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: gender,
                  hint: const Text('Select gender'),
                  items: genders.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextInput(
                  hint: 'Enter your phone number',
                  textEditingController: phoneController,
                  hideInput: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.contains(RegExp(r'^[0-9]+$')) == false) {
                      return 'Please enter a valid phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    // You might want to add more comprehensive phone number validation
                    return null;
                  },
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: signUpUser,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : const Text(
                          "Sign Up",
                        ),
                ),
                const SizedBox(height: 40),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TextInput widget remains the same as your previous code
