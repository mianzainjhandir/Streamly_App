
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamly_app/screens/main_navigation.dart';

class LogInController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<bool> logIn () async{
    String email = emailController.text.trim();
    String password = passController.text.trim();

    if(email.isEmpty || password.isEmpty){
      Get.snackbar("Error", "All fields are required!", backgroundColor: Colors.red);
      return false;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar("Success", "Logged in Successfully!", backgroundColor: Colors.green);

      // Fields Clear
      emailController.clear();
      passController.clear();

      // Navigate to Main Navigation (With Bottom Bar)
      Get.offAll(() => const MainNavigationScreen());

      return true; // ✅ Login Success
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(), backgroundColor: Colors.red);
      return false; // ❌ Login Failed
    }
  }
}