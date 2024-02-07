// intro_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:untitled6/screens/home_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<String> introImages = ['image1.jpg', 'image2.jpg', 'image3.jpg'];

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
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            if (index == introImages.length - 1) {
              // Last intro screen, navigate to home screen
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
      ),
    );
  }
}
