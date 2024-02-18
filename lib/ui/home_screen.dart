import 'package:chatting_app/ui/messaging_screen.dart';
import 'package:chatting_app/ui/view_all_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'auth/login.dart';
import 'package:chatting_app/firebase_services/user_info.dart' as user_info;

class HomeScreen extends StatefulWidget {
 final String id;
  const HomeScreen({super.key, required this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isHas = false;
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
                              userid: widget.id,
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
        body: StreamBuilder(
          stream: user_info.UserInfo().getUserInfo(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<String> userIds =
                snapshot.data!.docs.map((doc) => doc.id).toList();
            List userData =
                snapshot.data!.docs.map((doc) => doc.data() as Map).toList();
            return ListView.builder(
              itemCount: userIds.length,
              itemBuilder: (context, outerIndex) {
                String userId = userIds[outerIndex];
                var document = userData[outerIndex];
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('userinfo')
                      .doc(widget.id)
                      .collection('messages')
                      .doc(userId)
                      .collection('messageList')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> msgSnapshot) {
                    if (!msgSnapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    var lastMessage =
                        getLastMsg(msgSnapshot.data!.docs.last.data());
                    return ListTile(
                      onTap: () {
                        // print(""" currentUser :${auth.currentUser!.uid},
                        // userid :${document['userid']}""");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagingScreen(
                              messageList: user_info.UserInfo.getUserMessageList(
                                  widget.id, document['userid']),
                              docID: document['userid'],
                              userid: document['userid'],
                              name: document['name'],
                            ),
                          ),
                        );
                      },
                      title: Text("${document['name']} "),
                      subtitle: lastMessage,
                    );
                  },
                );
              },
            );
          },
        ));
  }

  getLastMsg(msgData) {
    String lastMsg;
    Map dataMsg = msgData;
    DateTime dateTime = (dataMsg['time']).toDate();
    DateTime lastMsgTime = dateTime.add(const Duration(hours: 6));
    DateTime now = DateTime.now();
    String showDate;
    if (now.day == lastMsgTime.day && now.month == lastMsgTime.month) {
      showDate = DateFormat('h:mm a').format(lastMsgTime);
    } else {
      showDate = DateFormat('MMMM d').format(lastMsgTime);
    }
    if (widget.id == dataMsg['userid']) {
      lastMsg = "You: ${dataMsg['message']} $showDate";
    } else {
      lastMsg = "${dataMsg['message']} $showDate";
    }
    return Text(lastMsg);
  }
}
