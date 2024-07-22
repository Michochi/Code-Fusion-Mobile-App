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
                opacity: 0.3,
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
            const Positioned(
              left: -500,
              top: 800,
              child: Opacity(
                opacity: 0.5,
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
                  const SizedBox(height: 20),
                  Text(
                    'CATEGORIES',
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      buildCategoryContainer(
                          'assets/Cryptography.png',
                          'CRYPTOGRAPHY',
                          screenWidth,
                          'assets/CryptoFrame.png'),
                      buildCategoryContainer(
                          'assets/Binary.png',
                          'BINARY EXPLOITATION',
                          screenWidth,
                          'assets/BinaryFrame.png'),
                      buildCategoryContainer(
                          'assets/Forensics.png',
                          'FORENSICS',
                          screenWidth,
                          'assets/ForensicsFRAME.png'),
                      buildCategoryContainer(
                          'assets/Reverse.png',
                          'REVERSE ENGINEERING',
                          screenWidth,
                          'assets/ReverseFrame.png'),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),
                        buildCategoryContainer(
                            'assets/Web.png',
                            'WEB EXPLOITATION',
                            screenWidth,
                            'assets/WebFrame.png'),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(50),
                    child: Image(
                      image: AssetImage('assets/quest.png'),
                      width: imageWidth2 + 30,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryContainer(
      String imagePath, String name, double screenWidth, String fullImagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          image: AssetImage(imagePath),
          width: screenWidth / 6,
          height: screenWidth / 6,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.dotGothic16(color: Colors.white, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _showImageDialog(context, fullImagePath);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9C27B0),
          ),
          child: Text('Info',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          contentPadding: EdgeInsets.zero,
          content: Image(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
