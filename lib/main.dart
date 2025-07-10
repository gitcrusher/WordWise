import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_player/loading_screen.dart';
import 'package:music_player/onboarding_screen.dart';
import 'package:music_player/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      print('Firebase initialized');
    } else {
      print('Firebase already initialized');
    }
  } catch (e) {
    print(' Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
