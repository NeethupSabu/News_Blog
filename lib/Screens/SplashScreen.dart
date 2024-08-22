import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one/Screens/OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    Timer(const Duration(seconds: 5), navigateToWalkthrough);
  }

  navigateToWalkthrough() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const OnboardingScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'), // Replace with your logo
      ),
    );
  }
}
