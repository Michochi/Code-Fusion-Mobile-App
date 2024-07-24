import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_registration/screens/challenge.dart';
import 'package:login_registration/screens/screen.dart';
import 'package:login_registration/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainBodyScreen extends StatefulWidget {
  const MainBodyScreen({super.key});

  @override
  State<MainBodyScreen> createState() => _MainBodyScreenState();
}

class _MainBodyScreenState extends State<MainBodyScreen> {
  int currentIndex = 1;

  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _screens = [
    const ChallengeScreen(),
    const Homescreen(),
    const MyProfile(),
  ];

  Future<int> _getPoints() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data()?['points'] ?? 0;
    }
    return 0;
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageWidth = screenWidth * 0.95;
    double imageHeight = imageWidth * (9 / 16);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color.fromARGB(50, 183, 0, 255),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(9.0),
            child: Image(image: AssetImage("assets/logocode.png")),
          ),
          backgroundColor: Color.fromARGB(25, 183, 0, 255),
          elevation: 0,
          title: FutureBuilder<int>(
            future: _getPoints(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(
                  'POINTS: 0',
                  style: GoogleFonts.dotGothic16(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        offset: const Offset(1.0, 1.0),
                        color: Colors.black.withOpacity(1),
                      ),
                      Shadow(
                        offset: const Offset(-1.0, -1.0),
                        color: Colors.black.withOpacity(1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                );
              }
              return Text(
                'POINTS: ${snapshot.data}',
                style: GoogleFonts.dotGothic16(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      offset: const Offset(1.0, 1.0),
                      color: Colors.black.withOpacity(1),
                    ),
                    Shadow(
                      offset: const Offset(-1.0, -1.0),
                      color: Colors.black.withOpacity(1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: Container(
          height: 40,
          color: Color.fromARGB(255, 153, 0, 255),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.developer_mode_outlined,
                  size: 25,
                  color: currentIndex == 0
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Colors.black,
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: currentIndex == 1
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Colors.black,
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 25,
                  color: currentIndex == 2
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Colors.black,
                ),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
