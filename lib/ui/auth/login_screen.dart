import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/PhoneNumberAuthenctication.dart';
import 'package:flutter_firebase/ui/auth/signup_screen.dart';
import 'package:flutter_firebase/ui/post_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },

      child: Scaffold(
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
                  "Login to continue",
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
                      padding: EdgeInsets.only(top: 70.0, bottom: 4.0),
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
                            return null;
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
                          } else if (!regex.hasMatch(value))
                          {
                              return 'Enter valid password';
                          }
                          else
                          {
                              return null;
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
                        login();
                      }
                  },
                  child: loading == true ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white,) : const Text('Login'),
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
                padding: const EdgeInsets.only(top: 30.0),
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
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneNumberAuthentication()));
                  },
                  child: const Text(
                    'Login with Phone Number',
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login()
  {
    if(_formKey.currentState!.validate())
      {
        setState(() {
          loading = true;
        });
        _auth.signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString()
        ).then((value){
          setState(() {
            loading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
        }).onError((error, stackTrace){
          setState(() {
            loading =false;
          });
          Utils().showToast(error.toString());
        });
      }
  }

}
