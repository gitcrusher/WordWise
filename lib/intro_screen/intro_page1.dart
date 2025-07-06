import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //tittle
              Text(
                "Hello, Welcome!",
                style: GoogleFonts.pacifico(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        Color(0xFFFFE0B2), // Soft cream-peach
                        Color(0xFFFFB774), // Muted orange
                        Color.fromARGB(255, 254, 123, 127), // Light warm pink
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 100.0)),
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color.fromARGB(255, 122, 41, 15),
                      offset: Offset(4, 4),
                    ),
                    Shadow(
                      blurRadius: 3,
                      color: Colors.white.withOpacity(0.4),
                      offset: Offset(-.5, -1),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),

              //Animation.
              Lottie.network(
                'https://lottie.host/61bfb41d-2479-4704-9ce2-9367759beafd/AQOJR7utpI.json',
                height: 325,
              ),
              // subtitle
              Text(
                "WordWise",
                style: GoogleFonts.pacifico(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        Color(0xFFFFE0B2), // Soft cream-peach
                        Color(0xFFFFB774), // Muted orange
                        Color.fromARGB(255, 254, 123, 127), // Light warm pink
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 100.0)),
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color.fromARGB(255, 122, 41, 15),
                      offset: Offset(4, 4),
                    ),
                    Shadow(
                      blurRadius: 3,
                      color: Colors.white.withOpacity(0.4),
                      offset: Offset(-.5, -1),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20),

              // Subtitle in cursive complementary font
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "Explore words, meanings, and videos with real-time smart suggestions.",
                  style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
