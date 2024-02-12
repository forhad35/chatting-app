import 'package:chatting_app/utilitis/display_size.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  String title;
  final VoidCallback onTap;
  bool loading;
   RoundedButton({super.key,
  required this.title,
     required this.onTap,
     this.loading = false ,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: displayWidth(context)*0.70,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10)
        ),
        child:loading ? const SizedBox(height:20,width:20,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,)) : Text(title,textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white
        ),),
      ),
    );
  }
}
