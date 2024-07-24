import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getBookmarks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No bookmarks found.'));
                    }

                    final bookmarks = snapshot.data!;

                    return ListView.builder(
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        final bookmark = bookmarks[index];
                        return ListTile(
                          title: Text(
                            bookmark['name'] ?? 'Unknown Challenge',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            bookmark['category'] ?? 'Unknown Category',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            '${bookmark['points'] ?? 0} Points',
                            style: const TextStyle(color: Colors.white70),
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
                  margin: const EdgeInsets.only(
                      top: 10), // Add margin above the top border
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
                    children: const [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
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
