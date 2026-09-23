
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamly_app/screens/home.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  Future<void> signUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String userName = userNameController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || userName.isEmpty) {
      Get.snackbar("Error", "All fields are required!", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // 1. Create user in Firebase Auth
      print("Starting Auth registration...");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Auth Success: ${userCredential.user!.uid}");

      // 2. Save user data to Firestore in 'docUser' collection
      print("Starting Firestore data saving...");
      await _firestore.collection('docUser').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'username': userName,
        'createdAt': FieldValue.serverTimestamp(),
      }).then((value) {
        print("Firestore Success: Document created");
      }).catchError((error) {
        print("Firestore Error Details: $error");
        throw error;
      });

      Get.snackbar("Success", "Account created successfully!", backgroundColor: Colors.green, colorText: Colors.white);

      // Clear fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      userNameController.clear();

      // Navigate to Home
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

// I build the logic of signup.