import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.blue,
        ),*/
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value)
                      {
                        if(value!.isEmpty)
                          {
                            return 'Email must be not empty';
                          }
                          else
                          {
                            return null;
                          }
                      },
                      decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !isPasswordVisible,
                      validator: (value)
                      {
                        if(value!.isEmpty){
                          return 'Password must be not empty';
                        }
                        else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    defaultButton(
                        width: double.infinity,
                        background: Colors.red,
                        function:(){
                          if(formKey.currentState!.validate()){
                            print(emailController.text);
                            print(passwordController.text);
                          }
                          },
                        text: 'login',
                    raduis: 6),
                SizedBox(height: 20,),
                    defaultButton(
                        function:(){
                          print(emailController.text);
                          print(passwordController.text);
                        },
                        text: 'REGISTER',
                    raduis: 6),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account ?'),
                        TextButton(
                            onPressed: () {}, child: Text('Register Now'))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
