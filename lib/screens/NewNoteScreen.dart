import 'package:ai_notes/auth/auth_service.dart';
import 'package:ai_notes/note/note.dart';
import 'package:ai_notes/note/note_database.dart';
import 'package:flutter/material.dart';

class Newnotescreen extends StatefulWidget {
  const Newnotescreen({super.key});

  @override
  State<Newnotescreen> createState() => _NewnotescreenState();
}

class _NewnotescreenState extends State<Newnotescreen> {
  final noteController = TextEditingController();
  final authService = AuthService();
  final notesDatabase = NoteDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: noteController),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    noteController.clear();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final newNote = Note(text: noteController.text);
                    await notesDatabase.createNote(newNote);

                    Navigator.pop(context);
                    noteController.clear();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
