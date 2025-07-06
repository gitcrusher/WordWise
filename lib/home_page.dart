import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/search_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner:
          false, // Starting from another screen to test back arrow
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _rotationAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _radiusAnimation = Tween(
      begin: 450.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF5F6D), Color(0xFF9D50BB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4), // deep shadow
                offset: Offset(0, 6), // down shadow
                blurRadius: 12, // soft edges
                spreadRadius: 1, // size of the shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // remove default shadow
            centerTitle: true,
            title: Text(
              'Word Wise',
              style: GoogleFonts.pacifico(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            //bigest object
            Transform.rotate(
              angle: _rotationAnimation.value + 0.2,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF692D94).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color(0xFF692D94),
                ),
              ),
            ),

            //second object
            Transform.rotate(
              angle: _rotationAnimation.value + 0.4,
              child: Container(
                width: 325,
                height: 325,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        106,
                        40,
                        153,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 106, 40, 153),
                ),
              ),
            ),

            //third object
            Transform.rotate(
              angle: _rotationAnimation.value + 0.6,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        94,
                        12,
                        152,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 94, 12, 152),
                ),
              ),
            ),

            //4th
            Transform.rotate(
              angle: _rotationAnimation.value + 0.8,
              child: Container(
                width: 275,
                height: 275,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        100,
                        27,
                        152,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 100, 27, 152),
                ),
              ),
            ),

            //5th
            Transform.rotate(
              angle: _rotationAnimation.value + 1,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        143,
                        32,
                        164,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 143, 32, 164),
                ),
              ),
            ),

            //6th
            Transform.rotate(
              angle: _rotationAnimation.value + 1.2,
              child: Container(
                width: 225,
                height: 225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        159,
                        61,
                        177,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 159, 61, 177),
                ),
              ),
            ),

            //7
            Transform.rotate(
              angle: _rotationAnimation.value + 1.4,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        158,
                        62,
                        178,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 158, 62, 178),
                ),
              ),
            ),

            //8th
            Transform.rotate(
              angle: _rotationAnimation.value + 1.6,
              child: Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        178,
                        84,
                        245,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 178, 84, 245),
                ),
              ),
            ),

            //9th
            Transform.rotate(
              angle: _rotationAnimation.value + 1.8,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        189,
                        106,
                        244,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 189, 106, 244),
                ),
              ),
            ),

            //10th
            Transform.rotate(
              angle: _rotationAnimation.value + 2,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        193,
                        125,
                        238,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 193, 125, 238),
                ),
              ),
            ),

            //11
            Transform.rotate(
              angle: _rotationAnimation.value + 2.2,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        223,
                        181,
                        226,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 223, 181, 226),
                ),
              ),
            ),
            //12
            Transform.rotate(
              angle: _rotationAnimation.value + 2.4,
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusAnimation.value),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        235,
                        213,
                        239,
                      ).withOpacity(0.8),
                      offset: const Offset(-6.0, -6.0),
                      // blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(6.0, 6.0),
                      // blurRadius: 16.0,
                    ),
                  ],
                  color: const Color.fromARGB(255, 235, 213, 239),
                ),
              ),
            ),

            //13
            Transform.rotate(
              angle: _rotationAnimation.value + 2.6,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AutocompleteSearchPage(),
                    ),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(_radiusAnimation.value),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          239,
                          222,
                          242,
                        ).withOpacity(0.8),
                        offset: const Offset(-6.0, -6.0),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(6.0, 6.0),
                      ),
                    ],
                    color: const Color.fromARGB(255, 239, 222, 242),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
