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

  final List<Widget> _screens = [
    const Challenge(),
    const Homescreen(),
    const MyProfile(),
  ];

  void _onItemTapped(int index) {
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
    double imageWidth = screenWidth * 0.95; // 80% of screen width
    double imageHeight = imageWidth * (9 / 16);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color.fromARGB(25, 183, 0, 255),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Image(image: AssetImage("assets/logocode.png")),
          ),
          backgroundColor: const Color.fromARGB(25, 183, 0, 255),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // Placeholder for centering
              Text(
                'POINTS: $points',
                style:
                    GoogleFonts.dotGothic16(color: Colors.white, fontSize: 18),
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
        body: _screens[currentIndex],
        bottomNavigationBar: Container(
          height: 40,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.developer_mode_outlined,
                  size: 25,
                  color: currentIndex == 0 ? Color(0xFF9125DA) : Colors.black,
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
                      ? const Color(0xFF9125DA)
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
                      ? const Color(0xFF9125DA)
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
