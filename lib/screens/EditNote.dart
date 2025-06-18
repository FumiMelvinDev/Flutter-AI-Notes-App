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
      appBar: AppBar(
        title: Text('Edit Note'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: noteController,
                    maxLines: 25,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Edit your note...',
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      noteController.clear();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
                    ),
                    child: Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await notesDatabase.updateNote(
                        widget.note,
                        noteController.text,
                      );
                      if (!mounted) return;
                      Navigator.pop(context);
                      noteController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
