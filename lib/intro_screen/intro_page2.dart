import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/7e2c0a86-8d97-4c68-a75b-8014db6cc774/168Ud4uEu2.json',
              height: 350,
            ),
            const SizedBox(height: 30),

            //tittle
            Text(
              "Smart Suggestion",
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
                    offset: Offset(-0.5, -1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            //subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Type just a few letters and get instant word matches.",
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
    );
  }
}
