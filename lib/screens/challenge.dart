import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_registration/screens/solve.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedCategory = 'All';

  Future<void> _bookmarkChallenge(Map<String, dynamic> challenge) async {
    final user = _auth.currentUser;
    if (user != null) {
      final bookmarkRef =
          _firestore.collection('users').doc(user.uid).collection('bookmarks');
      final querySnapshot =
          await bookmarkRef.where('name', isEqualTo: challenge['name']).get();
      if (querySnapshot.docs.isEmpty) {
        await bookmarkRef.add(challenge);
      } else {
        await querySnapshot.docs.first.reference.delete();
      }
      setState(() {});
    }
  }

  Future<bool> _isBookmarked(String challengeName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final bookmarkRef =
          _firestore.collection('users').doc(user.uid).collection('bookmarks');
      final querySnapshot =
          await bookmarkRef.where('name', isEqualTo: challengeName).get();
      return querySnapshot.docs.isNotEmpty;
    }
    return false;
  }

  Stream<List<Map<String, dynamic>>> _fetchChallenges() {
    return _firestore.collection('challenges').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? 'Unnamed',
          'category': data['category'] ?? 'Uncategorized',
          'points': data['points'] ?? 0,
          'description': data['description'] ?? 'No description',
          'difficulty': data['difficulty'] ?? 'No difficulty',
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.9;
    double imageHeight = imageWidth * (9 / 16);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Challenge Screen',
                  style: GoogleFonts.dotGothic16(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: <String>[
                    'All',
                    'Cryptography',
                    'Forensics',
                    'Web Exploit',
                    'Reverse Engineering',
                    'Binary Exploit'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.dotGothic16(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.black,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _fetchChallenges(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final challenges = snapshot.data!;
                      final filteredChallenges = selectedCategory == 'All'
                          ? challenges
                          : challenges
                              .where((challenge) =>
                                  challenge['category'] == selectedCategory)
                              .toList();

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: filteredChallenges.length,
                        itemBuilder: (context, index) {
                          final challenge = filteredChallenges[index];
                          return FutureBuilder<bool>(
                            future: _isBookmarked(challenge['name'] as String),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final isBookmarked = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SolveScreen(),
                                      settings: RouteSettings(
                                        arguments: {
                                          'name': challenge['name'] as String,
                                          'description':
                                              challenge['description']
                                                  as String,
                                          'difficulty':
                                              challenge['difficulty'] as String,
                                          'category':
                                              challenge['category'] as String,
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
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/ChallengeBoxDesign.png'),
                                      fit: BoxFit.fitWidth,
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
                                      const SizedBox(height: 10),
                                      Text(
                                        challenge['category'] as String,
                                        style: GoogleFonts.dotGothic16(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${challenge['points']} Points',
                                        style: GoogleFonts.dotGothic16(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _bookmarkChallenge(challenge);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
