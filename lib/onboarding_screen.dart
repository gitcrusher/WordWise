import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Home_page.dart';
import 'package:music_player/intro_screen/intro_page1.dart';
import 'package:music_player/intro_screen/intro_page2.dart';
import 'package:music_player/intro_screen/intro_page3.dart';
import 'package:music_player/splash_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: const [IntroPage1(), IntroPage2(), IntroPage3()],
          ),

          // Blurry Button at Bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (currentPage < 2) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentPage == 2 ? 'Done' : 'Get Started',
                            style: GoogleFonts.pacifico(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black38,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Only show arrow if NOT on last page
                          if (currentPage != 2)
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
