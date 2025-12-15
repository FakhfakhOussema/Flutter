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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            key: formKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: defaultText(text:'Log In',fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold)),
              defaultSizedBox(),
              defaultFormField(controller: loginController, type: TextInputType.emailAddress, label: 'Email Address', prefix: Icons.email,  validator: (value)
              {
                if(value!.isEmpty)
                {
                  return 'Email must be not empty';
                }
                else
                {
                  return null;
                }
              }
              ),
              defaultSizedBox(),
              defaultFormField(controller: passwordController, isPassword : true, type: TextInputType.visiblePassword, label: 'Password', prefix: Icons.lock, suffix: Icons.remove_red_eye, validator: (value)
              {
                if(value!.isEmpty){
                  return 'Password must be not empty';
                }
                else{
                  return null;
                }
              }),
              defaultSizedBox(),
              defaultButton(function: (){
              }, text: 'Log In'),
              defaultSizedBox(),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: defaultTextButton(
                      text: 'Forget your password',
                      onPressed: () {
                        print('hello');
                      },
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
