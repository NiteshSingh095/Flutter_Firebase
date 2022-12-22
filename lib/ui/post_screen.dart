import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/add_posts.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
{

  final _auth = FirebaseAuth.instance;
  
  final ref = FirebaseDatabase.instance.ref("Post");

  TextEditingController searchController = TextEditingController();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "search with title",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onChanged: (value){
                setState(() {

                });
              },
            ),
          ),
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot)
          //     {
          //       if(!snapshot.hasData)
          //         {
          //           return CircularProgressIndicator();
          //         }
          //       else
          //         {
          //           Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //
          //           List<dynamic> list = [];
          //
          //           list.clear();
          //
          //           list = map.values.toList();
          //
          //           return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index)
          //             {
          //               return ListTile(
          //                 title: Text(list[index]['title']),
          //                 subtitle: Text(list[index]['subtitle']),
          //               );
          //             },
          //           );
          //         }
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text("Loading"),
                itemBuilder: (context, snapshot, animation, index)
                {
                  if(searchController.text.isEmpty)
                    {
                      return ListTile(
                        title: Text(snapshot.child("title").value.toString()),
                        subtitle: Text(snapshot.child("subtitle").value.toString()),
                      );
                    }
                  else if(snapshot.child("title").value.toString().toLowerCase().contains(searchController.text.toLowerCase().toString()))
                    {
                      return ListTile(
                        title: Text(snapshot.child("title").value.toString()),
                        subtitle: Text(snapshot.child("subtitle").value.toString()),
                      );
                    }
                  else
                    {
                      return Container();
                    }
                }
            ),
          )
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
