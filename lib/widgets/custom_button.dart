import 'package:flutter/material.dart';

class Elevated_Button extends StatelessWidget {
  final String? text;
  final void Function()? otap;
  Elevated_Button({super.key, required this.otap, this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: otap,
      height: 50,
      minWidth: 100,
      color: Colors.blue.shade200,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      child: Text(
        text!,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
