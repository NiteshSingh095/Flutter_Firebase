import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 4.0),
              child: Text(
                "Welcome,",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 4.0),
              child: Text(
                "Sign in to continue",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100.0, bottom: 4.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        else if(!EmailValidator.validate(value, true))
                        {
                          return 'Invald email address';
                        }
                        else
                        {
                          return ' ';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value){
                        RegExp regex =
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        if (value == null || value.isEmpty)
                        {
                          return 'Please enter password';
                        } else {
                          if (!regex.hasMatch(value)) {
                            return 'Enter valid password';
                          } else {
                            return " ";
                          }
                        }
                      }
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  fixedSize: Size(1000, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate())
                    {

                    }
                },
                child: const Text('Login'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: Size(1000, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text(
                  'Continue With Google',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account."),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: const Text(
                      'SignUp',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
