import 'package:ai_notes/note/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  final database = Supabase.instance.client.from('Note');

  // CREATE
  Future createNote(Note newNote) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('No user logged in');
    final noteMap = newNote.toMap()..['authorId'] = userId;
    await database.insert(noteMap);
  }

  // READ
  Stream<List<Note>> notesForUser(String userId) {
    return Supabase.instance.client
        .from('Note')
        .stream(primaryKey: ['id'])
        .eq('authorId', userId)
        .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());
  }

  // Update
  Future updateNote(Note oldNote, String newText) async {
    await database.update({'text': newText}).eq('id', oldNote.id!);
  }

  // delete
  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
