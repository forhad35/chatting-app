import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_services/user-info.dart';
import 'messaging_screen.dart';

class ViewUser extends StatefulWidget {
  String userID;
   ViewUser({super.key, required this.userID});

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  var fireStore = FirebaseFirestore.instance.collection('userinfo').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("view user"),
      ),
      body: StreamBuilder(
          stream: fireStore,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  margin: const EdgeInsets.all(6),
                  child:document.id == currentUser()?null: OutlinedButton(
                      onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MessagingScreen(
                                  messageList: UserInfo
                                      .getUserMessageList(
                                      widget.userID, document.id),
                                  docID: document.id,
                                  userID: document['id'],
                                  name: document['name'],
                                )));
                       FirebaseFirestore.instance.collection('userinfo').doc(currentUser()).collection('messages').doc(document['id']).set({
                          'name': document['name'],
                          'userID': document['id'],
                          'time': FieldValue.serverTimestamp()
                        });

                      },
                      child: Text("${document['name']} ")),
                );
              }).toList(),
            );
          }),
    );
  }
}
