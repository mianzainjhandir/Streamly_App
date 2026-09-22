import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 5 seconds delay for splash screen
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => const HomeScreen()); // Navigate to HomeScreen and remove Splash from stack
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/img.png',
          fit: BoxFit.cover, // Image ko poori screen par fill karne ke liye
        ),
      ),
    );
  }
}
