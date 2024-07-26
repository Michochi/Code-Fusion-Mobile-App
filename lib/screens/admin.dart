import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addChallenge() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }
    await _firestore.collection('challenges').add({
      'name': _titleController.text,
      'description': _descriptionController.text,
    });
    _titleController.clear();
    _descriptionController.clear();
  }

  Future<void> _updateChallenge(
      String id, String title, String description) async {
    await _firestore.collection('challenges').doc(id).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> _removeChallenge(String id) async {
    await _firestore.collection('challenges').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Challenge Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Challenge Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addChallenge,
              child: Text('Add Challenge'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('challenges').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final challenges = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = challenges[index];
                      return ListTile(
                        title: Text(challenge['title']),
                        subtitle: Text(challenge['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _titleController.text = challenge['title'];
                                _descriptionController.text =
                                    challenge['description'];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Update Challenge'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _titleController,
                                          decoration: InputDecoration(
                                              labelText: 'Title'),
                                        ),
                                        TextField(
                                          controller: _descriptionController,
                                          decoration: InputDecoration(
                                              labelText: 'Description'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _updateChallenge(
                                              challenge.id,
                                              _titleController.text,
                                              _descriptionController.text);
                                          Navigator.pop(context);
                                          _titleController.clear();
                                          _descriptionController.clear();
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeChallenge(challenge.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
