
import 'package:chatting_app/ui/auth/registration.dart';
import 'package:chatting_app/ui/home_screen.dart';
import 'package:chatting_app/utilitis/shared_value_helper.dart';
import 'package:chatting_app/widgets/rounded_btton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utilitis/display_size.dart';
import '../../utilitis/toast_message.dart';

class Login extends StatefulWidget {

  const Login({super.key,
  });


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  final _EmailController = TextEditingController();
  final _PassController = TextEditingController();
  // var pass = "mypass";
  // var email = "saju123@gmail.com";
  bool  isLoading=false;
  final _loginkey = GlobalKey<FormState>();
  String? helper ;
  String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
// var isEnrollment = widget.courseId ;
  @override
  void initState() {
    if(isChecked.$) {
      _EmailController.text = sharedEmail.$;
      _PassController.text = sharedPass.$;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(" ${_EmailController.text }    ${_PassController.text}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: displayWidth(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _loginkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _EmailController,
                    validator: (value){
                      if(value == ""){
                        return " Please enter email";
                      }
                      else if(!RegExp(emailRegex).hasMatch(value!)){
                        return " Input Valid Email";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,

                    style: const TextStyle(height: 1,fontSize: 12),
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(color: Colors.red,fontSize: 12),
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email,size: 20,),
                      labelStyle: TextStyle(fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.orange)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.indigo)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),

                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value){
                      if(value == ""){
                        return " Please enter password";
                      }
                      return null;
                    },

                    controller: _PassController,
                    obscureText: passwordVisible,
                    style: const TextStyle(height: 1,fontSize: 12),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red,fontSize: 12),
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock,size: 20,),
                      labelStyle: const TextStyle(fontSize: 12,),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.orange)),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.indigo)),
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,size: 14,),
                        onPressed: () {
                          setState(
                                () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      alignLabelWithHint: false,
                      // filled: true,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15,bottom: 15,left: 15),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 0.7,
                          child: Checkbox(value: isChecked.$, onChanged: (value){

                              isChecked.$=value!;
                              isChecked.save();
                              setState(() {
                            });
                          },
                          ),
                        ),
                        const Text("Remember Me",style: TextStyle(fontSize: 12),),
                      ],
                    ),

                  ),
                  // login submit button
                  RoundedButton(
                      title: "Login",
                      onTap: _login,
                    loading: isLoading
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account!"),
                      TextButton(onPressed: (){
                        _EmailController.clear();
                        _PassController.clear();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Registration()), (route)=>false );
                      },
                          child: const Text("Register Here!")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _login(){

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isLoading = true;
    setState(() {
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: _EmailController.text, password: _PassController.text).then((value) {
      isLoading=false;
      toastMessage('Sing up success');
      if(_loginkey.currentState!.validate()){
        if(isChecked.$){
          sharedEmail.$ = _EmailController.text;
          sharedEmail.save();
          sharedPass.$ = _PassController.text;
          sharedPass.save();
        }

      }
      // getUserName(value.user!.email);
      Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen(id: value.user!.uid) ));
      setState(() {

      });

    }).catchError((error){
      isLoading = false;
      toastMessage(error.toString());

      setState(() {

      });
    }

    );
  }
  // getUserName(email) async{
  //   var userinfo = FirebaseFirestore.instance.collection('userinfo').where("email", whereIn:[ email]);
  //   await userinfo.get().then((value) {
  //     userName.$ = value.docs[0].data()['name'];
  //     userName.save();
  //     userName.load();
  //     print(userName.$);
  //   }).catchError((error){
  //     toastMessage(error);
  //   });
  // }
}
