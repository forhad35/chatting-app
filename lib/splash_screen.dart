import 'dart:async';

import 'package:chatting_app/firebase_services/splash_service.dart';
import 'package:chatting_app/utilitis/shared_value_helper.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    sharedEmail.load();
    sharedPass.load();
    isChecked.load();
    userName.load();
    SplashService.isLogin(context);
    animation();
  }

  double size = 12;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text(
          " Chat App",
          style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
        )));
  }

  animation() {
    Timer(const Duration(milliseconds: 1000), () {
      size = 16;
      setState(() {});
    });
    Timer(const Duration(milliseconds: 1000), () {
      size +=5;
      setState(() {});
    });
    Timer(const Duration(milliseconds: 980), () {
      size+=6;
      setState(() {});
    });
    // Timer(const Duration(milliseconds: 500), () {
    //   size +=2;
    //   setState(() {});
    // });
  }
}
