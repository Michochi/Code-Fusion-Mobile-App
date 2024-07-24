import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SolveScreen extends StatefulWidget {
  const SolveScreen({super.key});

  @override
  _SolveScreenState createState() => _SolveScreenState();
}

class _SolveScreenState extends State<SolveScreen> {
  final TextEditingController _flagController = TextEditingController();
  String _hint = "";

  Future<void> _completeChallenge(int points) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      final currentPoints = userDoc.data()?['points'] ?? 0;
      await userRef.update({'points': currentPoints + points});
    }
  }

  Future<void> _markChallengeAsCompleted(String challengeName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final challengeRef =
          userRef.collection('completedChallenges').doc(challengeName);
      await challengeRef.set({'completed': true});
    }
  }

  Future<void> _checkFlag() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final challengeData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final flag = _flagController.text;

      if (challengeData != null) {
        try {
          final challengeQuery = FirebaseFirestore.instance
              .collection('challenges')
              .where('name', isEqualTo: challengeData['name']);
          final challengeSnapshot = await challengeQuery.get();

          if (challengeSnapshot.docs.isNotEmpty) {
            final challengeDoc = challengeSnapshot.docs.first;
            final data = challengeDoc.data();
            final correctFlag = data['flag'] as String?;
            final points = data['points'] as int?;

            if (correctFlag != null && points != null) {
              final userRef =
                  FirebaseFirestore.instance.collection('users').doc(user.uid);
              final completedChallengesRef =
                  userRef.collection('completedChallenges');
              final completedChallengeDoc =
                  await completedChallengesRef.doc(challengeData['name']).get();

              if (completedChallengeDoc.exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Challenge already completed!')));
              } else if (flag == correctFlag) {
                await _completeChallenge(points);
                await _markChallengeAsCompleted(challengeData['name']);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Challenge completed!')));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Incorrect flag!')));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Challenge data is incomplete!')));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Challenge data not found!')));
          }
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Challenge name is missing!')));
      }
    }
  }

  void _showHint(int hintNumber) {
    setState(() {
      _hint = "Hint $hintNumber";
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> challengeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int points = challengeData['points'] as int? ?? 0;
    final String description =
        challengeData['description'] as String? ?? 'No description';
    final String difficulty =
        challengeData['difficulty'] as String? ?? 'No difficulty';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          challengeData['name'] ?? 'Challenge',
          style: GoogleFonts.dotGothic16(),
        ),
        backgroundColor: Color.fromARGB(255, 145, 37, 218),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${challengeData['name'] ?? 'No name'}',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description: $description',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Difficulty: $difficulty',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Category: ${challengeData['category'] ?? 'No category'}',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Points: $points',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _flagController,
              decoration: InputDecoration(
                labelText: 'Enter Flag',
                labelStyle: GoogleFonts.dotGothic16(
                  color: Color.fromARGB(180, 255, 255, 255),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5),
              ),
              style: GoogleFonts.dotGothic16(color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 145, 37, 218),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              onPressed: _checkFlag,
              child: Text(
                'Send',
                style: GoogleFonts.dotGothic16(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'HINT',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.5),
                      ),
                    ),
                    onPressed: () => _showHint(index + 1),
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.dotGothic16(color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
            if (_hint.isNotEmpty)
              Container(
                padding: EdgeInsets.all(10),
                color: const Color.fromARGB(255, 47, 47, 47),
                child: Text(
                  _hint,
                  style: GoogleFonts.dotGothic16(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
