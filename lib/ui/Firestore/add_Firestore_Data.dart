import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/utils/utils.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({Key? key}) : super(key: key);

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData>
{

  bool loading = false;

  final fireStore = FirebaseFirestore.instance.collection("Users");

  TextEditingController post = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add FireStore Data"),),
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

                  String id = DateTime.now().millisecond.toString();

                  fireStore.doc(id).set(
                      {
                        'id' : id,
                        'title' : post.text.toString(),
                        'subtitle' : post.text.toString(),
                      }
                  ).then((value){
                    Utils().showToast("Post added");
                    post.text = "";
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
