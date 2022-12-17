import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServics splashServics = SplashServics();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServics.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Firebase", style: TextStyle(fontSize: 30),),
      ),
    );
  }
}
