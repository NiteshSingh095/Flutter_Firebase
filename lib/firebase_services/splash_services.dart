import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/FireStore_Screen.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/ui/post_screen.dart';

class SplashServics
{
  void isLogin(BuildContext context)
  {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;

    if(user != null)
      {
        Timer(
            const Duration(seconds: 3),
                () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FireStoreScreen()))
        );
      }
    else
      {
        Timer(
            const Duration(seconds: 3),
                () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()))
        );
      }
  }
}