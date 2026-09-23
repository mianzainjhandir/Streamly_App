import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login/view.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check authentication state after delay
    Future.delayed(const Duration(seconds: 3), () {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // User already logged in -> Navigate directly to Main Navigation Screen
        Get.off(() => const MainNavigationScreen());
      } else {
        // User not logged in -> Navigate to Login Page
        Get.off(() => const LogInPage());
      }
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
