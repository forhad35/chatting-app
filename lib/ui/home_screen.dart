import 'package:chatting_app/ui/messaging_screen.dart';
import 'package:chatting_app/ui/view-all-user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../firebase_services/user-info.dart';
import 'auth/login.dart';
import 'package:chatting_app/firebase_services/user-info.dart' as userInfo;

class HomeScreen extends StatefulWidget {
  String id;
  HomeScreen({super.key, required this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isHas = false;
  var messageList;
  var senderName;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chat"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewUser(
                            userID: widget.id,
                          ))),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body:
      StreamBuilder(
          stream: userInfo.UserInfo().getUserInfo(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            print(""" currentUser :${auth.currentUser!.uid},
                              userID :${document['userID']}""");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagingScreen(
                                      messageList: userInfo.UserInfo
                                          .getUserMessageList(
                                          widget.id, document.id),
                                      docID: document.id,
                                      userID: document['userID'],
                                      name: document['name'],
                                    )));
                          },
                          child: Text("${document['name']}"))
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }

   getLastMsg() async{
    var firebaseMsg =await FirebaseFirestore.instance
        .collection('userinfo')
        .doc(currentUser())
        .collection('messages').get();
   firebaseMsg.docs.map((document) async {
     messageList =
     await FirebaseFirestore.instance.collection('userinfo').doc(widget.id)
         .collection('messages').doc(document.id).collection('messageList')
         .orderBy('time', descending: false)
         .get();
     Map msgData = messageList.docs.last.data();
     String lastMsg;
     if (widget.id == msgData['userID']) {
       lastMsg = "You: ${msgData['message']}";
     } else {
       lastMsg = msgData['message'].toString();
     }

     return Scaffold(

     );

   });
    // messageList =await FirebaseFirestore.instance.collection('userinfo').doc(id).collection('messages').doc(userid).collection('messageList').orderBy('time', descending: false).get();
    // Map msgData = messageList.docs.last.data();
    // String msg;
    // if(widget.id == msgData['userID']){
    //   msg ="You: ${msgData['message']}";
    // }else{
    //   msg =msgData['message'].toString();
    //
    // }
    print("firebaseMsg.values");
    // return msg;
  }
}
