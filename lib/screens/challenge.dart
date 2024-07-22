import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_registration/screens/solve.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the desired width and height of the image
    double imageWidth = screenWidth * 0.9; // 90% of screen width
    double imageHeight = imageWidth * (9 / 16); // Maintain aspect ratio of 16:9

    // Sample challenge data
    final challenges = [
      {
        'name': 'Challenge 1',
        'category': 'Forensic',
        'points': 100,
      },
      {
        'name': 'Challenge 2',
        'category': 'Cryptography',
        'points': 200,
      },
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          Positioned(
            left: -500,
            top: -500,
            child: Opacity(
              opacity: 0.2,
              child: Image(
                image: AssetImage('assets/Ellipse.png'),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 250,
            child: Opacity(
              opacity: 0.2,
              child: Image(
                image: AssetImage('assets/Ellipse.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Challenge Screen',
                  style: GoogleFonts.dotGothic16(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = challenges[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SolveScreen(),
                              settings: RouteSettings(
                                arguments: {
                                  'name': challenge['name'] as String,
                                  'description': 'Challenge Description',
                                  'difficulty': 'Challenge Difficulty',
                                  'category': challenge['category'] as String,
                                  'points': challenge['points'] as int,
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/ChallengeBoxDesign.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                challenge['name'] as String,
                                style: GoogleFonts.dotGothic16(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                challenge['category'] as String,
                                style: GoogleFonts.dotGothic16(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${challenge['points']} Points',
                                style: GoogleFonts.dotGothic16(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
