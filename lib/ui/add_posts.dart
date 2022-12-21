import 'package:flutter/material.dart';

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
                validator: (value) {
                  if (value == null || value.isEmpty)
                  {
                    return 'Please enter password';
                  }
                  else
                  {
                    return null;
                  }
                },
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
                if(_formKey.currentState!.validate())
                  {

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
