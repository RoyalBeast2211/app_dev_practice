import 'package:flutter/material.dart';
import 'package:ids/splash.dart';

void main() {
  runApp(const Cropper());
}

class Cropper extends StatelessWidget {
  const Cropper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
