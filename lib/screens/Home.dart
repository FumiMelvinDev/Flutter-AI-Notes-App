import 'package:ai_notes/auth/auth_service.dart';
import 'package:ai_notes/note/note.dart';
import 'package:ai_notes/note/note_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final noteController = TextEditingController();
  final authService = AuthService();
  final notesDatabase = NoteDatabase();

  void logout() async {
    await authService.sighOut();
  }

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: TextField(controller: noteController),
        actions: [
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
    );
  }

  void updateNote(Note note) {
    noteController.text = note.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: TextField(controller: noteController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await notesDatabase.updateNote(note, noteController.text);

              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteNote(Note note) async {
    await notesDatabase.deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: notesDatabase.stream,

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return ListTile(
                title: Text(note.text),
                trailing: IconButton(
                  onPressed: () {
                    deleteNote(note);
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              );
            },
          );
        },
      ),
      // body: SafeArea(
      //   child: IconButton(onPressed: logout, icon: Icon(Icons.logout)),
      // ),
    );
  }
}
