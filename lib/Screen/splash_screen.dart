import 'dart:async';
import 'package:elite_admin_panel/Screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.off(MainScreen(),transition: Transition.fade);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 80,
          width: 80,
          child: Animate(
            effects: [
              FadeEffect(),
              SlideEffect(
                begin: Offset(0.0, 0.5),
              ),
            ],  
            child: Image.asset("assets/logo/Elite_Icon.png",),
          ),
        ),
      ),
    );
  }
}