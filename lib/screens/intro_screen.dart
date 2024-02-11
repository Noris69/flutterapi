import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/screens/home_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<String> introImages = ['image1.png', 'image2.png', 'image3.png',''];

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (!isFirstLaunch) {
      // Not the first launch, navigate to home screen directly
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _setFirstLaunchFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstLaunch', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        items: introImages.map((image) {
          return Image.asset(
            'assets/$image',
            fit: BoxFit.cover,
          );
        }).toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 10.0,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            if (index == introImages.length -1) {
              // Last intro screen, set first launch flag and navigate to home screen
              _setFirstLaunchFlag();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}
