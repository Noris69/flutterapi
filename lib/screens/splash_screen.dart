import 'package:flutter/material.dart';
import 'package:untitled6/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Initial opacity value

  @override
  void initState() {
    super.initState();
    // Start animation after a delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0; // Update opacity to fully visible
      });
    });
    // Navigate to the next screen after a delay
    Future.delayed(
      Duration(seconds: 3),
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
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 5), // Duration of the animation
          opacity: _opacity, // Opacity value controlled by the animation
          child: Image.asset(
            'assets/splash.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
