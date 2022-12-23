import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/add_posts.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/utils/utils.dart';

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
  TextEditingController editController = TextEditingController();

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
                      String Title = snapshot.child("title").value.toString();
                      String id = snapshot.child("id").value.toString();

                      return ListTile(
                        title: Text(Title),
                        subtitle: Text(snapshot.child("subtitle").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(Title, id);
                                },
                                leading: const Icon(Icons.edit),
                                title: Text("Edit"),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  ref.child(snapshot.child("id").value.toString()).remove();
                                },
                                leading: const Icon(Icons.delete),
                                title: Text("Delete"),
                              ),
                            )
                          ],
                        ),

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

  Future<void> showMyDialog(String title, String id) async
  {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextFormField(
                controller: editController,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")
              ),
              TextButton(
                  onPressed: (){
                    ref.child(id).update({
                      'title' : editController.text.toString(),
                      'subtitle' : editController.text.toString()
                    }).then((value){
                      Utils().showToast("Post Updated");
                    }).onError((error, stackTrace){
                      Utils().showToast(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Update")
              ),
            ],
          );
        }
    );
  }
}
