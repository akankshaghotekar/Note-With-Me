import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_with_me/domain/constants/ui_helper.dart';
import 'package:note_with_me/repository/screens/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiHelper.splashBgColor,
      body: Center(child: Image.asset('assets/images/splash_img.png')),
    );
  }
}
