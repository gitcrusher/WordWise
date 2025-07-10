import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/Home_page.dart';
import 'package:music_player/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _scale = 1.5; // Initial zoomed-in size
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animation controller for scaling
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Start animation after slight delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _scale = 1.0; // Zoom out to normal size
      });
      _controller.forward(); // Start the animation
    });

    // Navigate to HomePage after animation completes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFCBA4), // Soft Peach
              Color(0xFFFF5F6D), // Warm Coral
              Color(0xFF9D50BB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            child: Image.asset('assets/images/Ww.png', width: 180, height: 180),
          ),
        ),
      ),
    );
  }
}
