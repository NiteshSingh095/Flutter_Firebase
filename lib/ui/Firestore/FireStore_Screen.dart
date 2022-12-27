import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/ui/Firestore/add_Firestore_Data.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/utils/utils.dart';



class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen>
{
  final _auth = FirebaseAuth.instance;

  final fireStore = FirebaseFirestore.instance.collection("Users").snapshots();
  final fireStoreCollection = FirebaseFirestore.instance.collection("Users");

  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FireStore Screen"),
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
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: fireStore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
              {
                if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return CircularProgressIndicator(strokeWidth: 2, color: Colors.black,);
                  }

                if(snapshot.hasError)
                  {
                    return Text("Some issue happen while fetching data");
                  }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index)
                  {
                    String title = snapshot.data!.docs[index]['title'].toString();
                    String id = snapshot.data!.docs[index]['id'].toString();

                    if(searchController.text.isEmpty)
                    {
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]['title'].toString()),
                        subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title, id);
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
                                  fireStoreCollection.doc(id).delete();
                                },
                                leading: const Icon(Icons.delete),
                                title: Text("Delete"),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    else if(title.toLowerCase().contains(searchController.text.toLowerCase().toString()))
                    {
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]['title'].toString()),
                        subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title, id);
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
                                  fireStoreCollection.doc(id).delete();
                                },
                                leading: const Icon(Icons.delete),
                                title: Text("Delete"),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    else
                    {
                      return Container();
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, left: 10.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddFireStoreData()));
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
                    fireStoreCollection.doc(id).update(
                      {
                        "title" : editController.text.toString()
                      }
                    ).then((value){
                      Utils().showToast("Updated Successfully");
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
