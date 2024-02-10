// main.dart
import 'package:flutter/material.dart';
import 'package:untitled6/screens/home_screen.dart';
import 'package:untitled6/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ynov News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false, // Désactiver l'icône de débogage

    );
  }
}
