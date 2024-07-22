import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_registration/screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBodyScreen extends StatefulWidget {
  const MainBodyScreen({super.key});

  @override
  State<MainBodyScreen> createState() => _MainBodyScreenState();
}

class _MainBodyScreenState extends State<MainBodyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int currentIndex = 1; // Default to HomeScreen
  int points = 100; // Example points value, you can update it as needed

  final PageController _pageController =
      PageController(initialPage: 1); // Initialize PageController

  final List<Widget> _screens = [
    const ChallengeScreen(), // Use ChallengeScreen
    const Homescreen(),
    const MyProfile(),
  ];

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

  Future<void> _clearLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate image size based on screen width
    double imageWidth = screenWidth * 0.95; // 95% of screen width
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // Placeholder for centering
              Text(
                'POINTS: $points',
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
              ),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  await _clearLoginInfo();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
                child: const Icon(Icons.logout),
              ),
            ],
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
