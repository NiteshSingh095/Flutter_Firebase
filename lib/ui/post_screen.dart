import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/add_posts.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
{

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Screen"),
        actions: [
          IconButton(
              onPressed: (){
                _auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.logout)
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, left: 10.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPosts()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
