import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';

class SplashServics
{
  void isLogin(BuildContext context)
  {
    Timer(
      const Duration(seconds: 3),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()))
    );
  }
}