import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate image size based on screen width
    double imageWidth = screenWidth * 0.85;
    double imageWidth2 = screenWidth * 0.50;
    double imageHeight = imageWidth * (9 / 16);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned(
              left: -500,
              top: -500,
              child: Opacity(
                opacity: 0.2,
                child: Image(
                  image: AssetImage('assets/Ellipse.png'),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              top: 250,
              child: Opacity(
                opacity: 0.2,
                child: Image(
                  image: AssetImage('assets/Ellipse.png'),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Image(
                      image: const AssetImage('assets/Frame20.png'),
                      width: imageWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Welcome to "Code Fusion," an exhilarating Capture The Flag (CTF) Hackathon that pushes the boundaries of coding prowess and cybersecurity acumen.',
                          textStyle: GoogleFonts.dotGothic16(
                              color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(50),
                    child: Image(
                      image: AssetImage('assets/categories.png'),
                      width: imageWidth2,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(50),
                    child: Image(
                      image: AssetImage('assets/quest.png'),
                      width: imageWidth2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Image(
                      image: const AssetImage('assets/hackaon.png'),
                      width: imageWidth,
                      height: imageHeight + 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '''Capture the Flag isn't just a game; it's a journey of continuous learning,
where every challenge is a step closer to mastering the art of cybersecurity.''',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w100),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
