import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _username = userDoc['username'];
      });
    }
  }

  Future<void> _clearLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  Future<List<Map<String, dynamic>>> _getBookmarks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final bookmarkRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks');
      final querySnapshot = await bookmarkRef.get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
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
            left: -250,
            top: 50,
            height: 1600,
            child: Opacity(
              opacity: 0.4,
              child: Image(
                image: AssetImage('assets/Ellipse.png'),
              ),
            ),
          ),
          const Positioned(
            left: -500,
            top: 1100,
            child: Opacity(
              opacity: 0.5,
              child: Image(
                image: AssetImage('assets/Ellipse.png'),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Text(
                  'Hello, ${_username ?? 'User'}!',
                  style: GoogleFonts.dotGothic16(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Text(
                'Your bookmarks:',
                style: GoogleFonts.dotGothic16(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getBookmarks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        'No bookmarks found.',
                        style: GoogleFonts.dotGothic16(
                          color: Colors.white,
                        ),
                      ));
                    }

                    final bookmarks = snapshot.data!;

                    return ListView.builder(
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        final bookmark = bookmarks[index];
                        return ListTile(
                          title: Text(
                            bookmark['name'] ?? 'Unknown Challenge',
                            style: GoogleFonts.dotGothic16(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            bookmark['category'] ?? 'Unknown Category',
                            style: GoogleFonts.dotGothic16(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            '${bookmark['points'] ?? 0} Points',
                            style: GoogleFonts.dotGothic16(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await _auth.signOut();
                  await _clearLoginInfo();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white),
                    ),
                    color: Colors.transparent,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: GoogleFonts.dotGothic16(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
