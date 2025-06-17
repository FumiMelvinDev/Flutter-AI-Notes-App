import 'package:ai_notes/auth/auth_service.dart';
import 'package:ai_notes/note/note.dart';
import 'package:ai_notes/note/note_database.dart';
import 'package:flutter/material.dart';

class Editnote extends StatefulWidget {
  final Note note;
  const Editnote({super.key, required this.note});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  final noteController = TextEditingController();
  final authService = AuthService();
  final notesDatabase = NoteDatabase();

  @override
  void initState() {
    super.initState();
    noteController.text = widget.note.text;
  }

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
                    await notesDatabase.updateNote(
                      widget.note,
                      noteController.text,
                    );

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
