import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_registration/screens/add.dart';
import 'package:login_registration/screens/screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signin': (context) => const MyRegistration(),
        '/profile': (context) => const MyProfile(),
        '/home': (context) => const Homescreen(),
        '/challenge': (context) => const ChallengeScreen(),
      },
      title: 'Login And Registration',
      theme: ThemeData(
        textTheme: const TextTheme().copyWith(
          bodySmall: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          labelSmall: const TextStyle(color: Colors.white),
          labelMedium: const TextStyle(color: Colors.white),
          labelLarge: const TextStyle(color: Colors.white),
          displaySmall: const TextStyle(color: Colors.white),
          displayMedium: const TextStyle(color: Colors.white),
          displayLarge: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
