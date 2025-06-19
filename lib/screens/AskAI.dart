import 'package:flutter/material.dart';
import 'package:ai_notes/ai/ai_service.dart';
import 'package:ai_notes/note/note_database.dart';

class AskAIScreen extends StatefulWidget {
  const AskAIScreen({super.key});

  @override
  State<AskAIScreen> createState() => _AskAIScreenState();
}

class _AskAIScreenState extends State<AskAIScreen> {
  final GeminiService geminiService = GeminiService();
  final NoteDatabase notesDatabase = NoteDatabase();
  final TextEditingController questionController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<_ChatMessage> messages = [];
  bool loading = false;

  Future<void> askAI() async {
    final question = questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      messages.add(_ChatMessage(text: question, isUser: true));
      loading = true;
      questionController.clear();
    });

    // Fetch notes from Supabase
    final notesResult = await notesDatabase.database.select();
    final notes = notesResult
        .map(
          (n) => {
            'text': n['text'],
            'createdAt': n['created_at'] ?? n['createdAt'],
            'updatedAt': n['updated_at'] ?? n['updatedAt'],
          },
        )
        .toList();

    if (notes.isEmpty) {
      setState(() {
        messages.add(_ChatMessage(text: 'No notes found.', isUser: false));
        loading = false;
      });
      _scrollToBottom();
      return;
    }

    try {
      final response = await geminiService.askAboutNotes(
        notes: notes,
        newQuestions: [question],
        responses: [],
      );
      setState(() {
        messages.add(_ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        messages.add(_ChatMessage(text: 'Error: $e', isUser: false));
      });
    }
    setState(() {
      loading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask AI About My Notes')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8)
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        hintText: 'Type your question...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      minLines: 1,
                      maxLines: 3,
                      onSubmitted: (_) => loading ? null : askAI(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: loading ? null : askAI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text('Ask'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
