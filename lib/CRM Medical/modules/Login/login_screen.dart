import 'package:app_examen/CRM%20Medical/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              reverse: true, // fait remonter le formulaire quand le clavier s'ouvre
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titre
                    Center(
                      child: defaultText(
                        text: 'Log In App CRM',
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    defaultSizedBox(),

                    // Email
                    defaultFormField(
                      controller: loginController,
                      type: TextInputType.emailAddress,
                      label: 'Email Address',
                      prefix: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email must not be empty';
                        }
                        return null;
                      },
                    ),
                    defaultSizedBox(),

                    // Password
                    defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      label: 'Password',
                      prefix: Icons.lock,
                      isPassword: isPassword,
                      suffix: isPassword ? Icons.visibility : Icons.visibility_off,
                      suffixPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password must not be empty';
                        }
                        return null;
                      },
                    ),
                    defaultSizedBox(),

                    // Login button
                    defaultButton(
                      text: 'Log In',
                      function: () {
                        if (formKey.currentState!.validate()) {
                          _onAuthentifier(context);
                        }
                      },
                    ),
                    defaultSizedBox(),

                    // Forget password
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: defaultTextButton(
                            text: 'Forget your password',
                            onPressed: () {
                              print('Forget password clicked');
                            },
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onAuthentifier(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/home",
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          message = 'Email or password is incorrect';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later';
          break;
        default:
          message = 'Authentication failed. Please try again';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}