import 'package:app_examen/CRM%20Medical/shared/components/components.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: defaultText(
                  text: 'Log In',
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              defaultSizedBox(),

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

              defaultButton(
                text: 'Log In',
                function: () {
                  if (formKey.currentState!.validate()) {
                    print('Email: ${loginController.text}');
                    print('Password: ${passwordController.text}');
                  }
                },
              ),

              defaultSizedBox(),

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
    );
  }
}
