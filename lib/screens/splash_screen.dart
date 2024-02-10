// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled6/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3), // Change the duration as needed
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntroScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        // Use an Image widget with AssetImage to display the image
        child: Image.asset(
          'assets/splash.png', // Path to your splash image
          width: 200, // Adjust width and height as needed
          height: 200,
        ),
      ),
    );
  }
}
