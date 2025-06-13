import 'package:uuid/uuid.dart'; // Add this import

class Note {
  String? id;
  String text;

  Note({String? id, required this.text}) : id = id ?? const Uuid().v4();

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'] as String, text: map['text'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text};
  }
}
