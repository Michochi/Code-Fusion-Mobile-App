import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Image(image: AssetImage("assets/logocode.png")),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
