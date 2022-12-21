import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/utils/utils.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({Key? key}) : super(key: key);

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts>
{

  bool loading = false;

  TextEditingController post = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final databaseRef =  FirebaseDatabase.instance.ref("Post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Post"),),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 4.0, left: 20, right: 20),
              child: TextFormField(
                key: _formKey,
                controller: post,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What is in your mind ?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 20, right: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                fixedSize: Size(1000, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                {
                  setState(() {
                    loading = true;
                  });
                  databaseRef.child("1").set(
                      {
                        'title' : post.text.toString()
                      }
                  ).then((value){
                    Utils().showToast("Post added");
                    setState(() {
                      loading = false;
                    });

                  }).onError((error, stackTrace){
                    Utils().showToast(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }
              },
              child: loading == true ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white,) : const Text('Add Post'),
            ),
          ),
        ],
      ),
    );
  }
}
