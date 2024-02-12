import 'dart:async';
import 'package:chatting_app/ui/auth/login.dart';
import 'package:chatting_app/ui/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SplashService{
 static void isLogin(BuildContext context){
    FirebaseAuth  auth = FirebaseAuth.instance;

   var user =auth.currentUser;

   if(user!= null){
      Timer(const Duration(seconds: 3), (){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(id: user.uid)), (route) => false);

      });
    }else{
      Timer(const Duration(seconds: 3), ()=>
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Login()), (route) => false));

    }

  }

}