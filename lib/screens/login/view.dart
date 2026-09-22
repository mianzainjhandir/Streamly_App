

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
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
              Gap(15),
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
            ],
          ),
        ),
      ),
    );
  }
}
