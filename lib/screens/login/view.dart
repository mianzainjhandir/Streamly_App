

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/social_button.dart';
import '../../widget/textfield.dart';
import '../forgot_password/view.dart';
import 'logic.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final LogInController controller = Get.put(LogInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 35,left: 10,right: 10),
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
              Text(
                "Welcome back!",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w300
                )
              ),
              Text(
                  "Sign in to continue",
                  style: GoogleFonts.poppins(
                      color: Colors.black45,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  )
              ),
              Gap(10),
              CustomTextField(
                controller: controller.emailController,
                hintText: 'Email or Username',
                prefixIcon: Icons.email_outlined,
                focusColor: Colors.indigo,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              // Password Field using CustomTextField
              CustomTextField(
                controller: controller.passController,
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
                    controller.logIn();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: (){
                            Get.to(()=> ForgotPassword());
                          },
                          child: Text("Forgot Password?",style: TextStyle(color: Colors.purple),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
              SocialLoginButtons(
                onGoogleTap: () {
                  print("Google Login");
                },
                onMicroSoftTap: () {
                  print("Facebook Login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
