import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_player/home_page.dart';
import 'package:music_player/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      print(
        '✅ Firebase initialized',
      ); // Or use logger.i if you’ve set up logging
    } else {
      print('ℹ️ Firebase already initialized'); // Or use logger.i
    }
  } catch (e) {
    print('🔥 Firebase initialization error: $e'); // Or use logger.e
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
    );
  }
}
