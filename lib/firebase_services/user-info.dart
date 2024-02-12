import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


String currentUser(){
  FirebaseAuth  auth = FirebaseAuth.instance;
  return auth.currentUser!.uid.toString();
}

class UserInfo{
   getUserInfo(){
    var firebaseMsg = FirebaseFirestore.instance.collection('userinfo').doc(currentUser()).collection('messages').snapshots();
    return firebaseMsg;
  }

 static setSendMessage (senderId, docID){
   CollectionReference<Map<String, dynamic>> messageList;
        messageList = FirebaseFirestore.instance.collection('userinfo').doc(senderId).collection('messages').doc(docID).collection('messageList');
    return messageList;
  }

 static getUserMessageList(id,userid){
   var messageList = FirebaseFirestore.instance.collection('userinfo').doc(id).collection('messages').doc(userid).collection('messageList');
   return messageList;
  }
  static getCurrentUserName(){
  var getUserName =   FirebaseFirestore.instance.collection('userinfo').doc(currentUser()).get();
     // print( "error  ${
     return   getUserName.then((event) => event.data()!['name']);
       // print(event.data()!['name']);
     // }");

  }

}