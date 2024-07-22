import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookmarks found.'));
          }

          final bookmarks = snapshot.data!;

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text(
                  bookmark['name'] ?? 'Unknown Challenge',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  bookmark['category'] ?? 'Unknown Category',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '${bookmark['points'] ?? 0} Points',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
