import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});
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
              'https://lottie.host/0297dff9-bc7e-4850-a78b-431dcb2bde06/IUwsEG2NFR.json',
              height: 350,
            ),
            const SizedBox(height: 30),

            //tittle
            Text(
              "Know More Than Words",
              style: GoogleFonts.pacifico(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      Color(0xFFFFF3C0), // soft pastel yellow (base)
                      Color(0xFFFFC197), // warm light coral
                      Color(0xFFF88379), // peach pink (accents)
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
                "Get accurate meanings and top YouTube videos related to your search.",
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
