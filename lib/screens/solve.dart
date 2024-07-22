import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SolveScreen extends StatefulWidget {
  const SolveScreen({super.key});

  @override
  _SolveScreenState createState() => _SolveScreenState();
}

class _SolveScreenState extends State<SolveScreen> {
  final TextEditingController _flagController = TextEditingController();
  String _hint = "";

  void _checkFlag() {
    // flag checking it's either sa database or dito nalang ilagay
  }

  void _showHint(int hintNumber) {
    setState(() {
      _hint = "Hint $hintNumber"; // dito yung mga hints typeshit
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> challengeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
              'Name: ${challengeData['name']}',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${challengeData['description']}',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Difficulty: ${challengeData['difficulty']}',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Category: ${challengeData['category']}',
              style: GoogleFonts.dotGothic16(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Points: ${challengeData['points']}',
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
                color: Colors.grey[200],
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
