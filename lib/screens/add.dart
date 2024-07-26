import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHintScreen extends StatefulWidget {
  @override
  _AddHintScreenState createState() => _AddHintScreenState();
}

class _AddHintScreenState extends State<AddHintScreen> {
  final TextEditingController _challengeNameController =
      TextEditingController();
  final TextEditingController _hintNumberController = TextEditingController();
  final TextEditingController _hintTextController = TextEditingController();

  Future<void> _addHint() async {
    final challengeName = _challengeNameController.text;
    final hintNumber = _hintNumberController.text;
    final hintText = _hintTextController.text;

    if (challengeName.isNotEmpty &&
        hintNumber.isNotEmpty &&
        hintText.isNotEmpty) {
      try {
        final hintDocId = 'hint$hintNumber';
        await FirebaseFirestore.instance
            .collection('challenges')
            .doc(challengeName)
            .collection('hints')
            .doc(hintDocId)
            .set({'hintText': hintText});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hint added successfully!')),
        );

        // Clear the form fields
        _challengeNameController.clear();
        _hintNumberController.clear();
        _hintTextController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding hint: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Hint',
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
            TextField(
              controller: _challengeNameController,
              decoration: InputDecoration(
                labelText: 'Challenge Name',
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
            TextField(
              controller: _hintNumberController,
              decoration: InputDecoration(
                labelText: 'Hint Number',
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
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _hintTextController,
              decoration: InputDecoration(
                labelText: 'Hint Text',
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
            SizedBox(height: 20),
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
              onPressed: _addHint,
              child: Text(
                'Add Hint',
                style: GoogleFonts.dotGothic16(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
