
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamly_app/screens/signup/logic.dart';

import '../../widget/textfield.dart';
import '../login/view.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignUpController controller = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Screen par kahin bhi tap karne se focus khatam ho jayega
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/images/logo.png',fit: BoxFit.cover,)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Stream',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'ly',
                          style: GoogleFonts.poppins(
                            color: Colors.deepPurple,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Create Account",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Join and start watching & creating",
                              style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ],
                      ),
                    ],
                  ),

                  Gap(10),
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: 'Full Name',
                    prefixIcon: Icons.person_outline,
                    focusColor: Colors.indigo,
                    helperText: "Please enter your full name",
                  ),
                  Gap(10),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    focusColor: Colors.indigo,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Gap(10),
                  CustomTextField(
                    controller: controller.userNameController,
                    hintText: 'Username',
                    prefixIcon: Icons.motion_photos_pause_rounded,
                    focusColor: Colors.indigo,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  // Password Field using CustomTextField
                  CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    focusColor: Colors.indigo,

                  ),
                  Gap(15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.signUp();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Get.to(()=> const LogInPage());
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: "Log In",
                                style: GoogleFonts.poppins(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
