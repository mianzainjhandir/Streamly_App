import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F0F1A),
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
