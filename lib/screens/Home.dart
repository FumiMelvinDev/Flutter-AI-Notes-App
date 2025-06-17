import 'package:ai_notes/auth/auth_service.dart';
import 'package:ai_notes/note/note.dart';
import 'package:ai_notes/note/note_database.dart';
import 'package:ai_notes/screens/EditNote.dart';
import 'package:ai_notes/screens/NewNoteScreen.dart';
import 'package:ai_notes/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

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

  void deleteNote(Note note) async {
    await notesDatabase.deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(
            'Notes',
            style: GoogleFonts.dmSerifText(
              fontSize: 56,
              color: Theme.of(context).colorScheme.inversePrimary,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Newnotescreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'AI Notes ',
                        style: TextStyle(fontSize: 36, color: Colors.purple),
                      ),
                      TextSpan(
                        text: 'App',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.deepOrange[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Notes',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,
                ),
              ),
              leading: Icon(Icons.home),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(
                'Ask AI',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,
                ),
              ),
              leading: Icon(Icons.home),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,
                ),
              ),
              leading: Icon(Icons.logout_outlined),
              onTap: logout,
            ),
            ListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,
                ),
              ),
              leading: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(),
              ),
            ),
          ],
        ),
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

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ListTile(
                  title: Text(note.text),
                  contentPadding: EdgeInsets.only(left: 16),
                  horizontalTitleGap: 8,
                  minVerticalPadding: 16,
                  dense: false,
                  titleAlignment: ListTileTitleAlignment.threeLine,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (popoverContext) => IconButton(
                          onPressed: () => showPopover(
                            context: popoverContext,
                            bodyBuilder: (context) => Container(
                              width: 120,
                              height: 120,
                              color: Theme.of(context).colorScheme.surface,
                              child: Center(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Edit'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Editnote(note: note),
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.edit),
                                    ),
                                    ListTile(
                                      title: Text('Delete'),
                                      onTap: () {
                                        deleteNote(note);
                                      },

                                      leading: Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            direction: PopoverDirection.bottom,
                          ),
                          icon: Icon(Icons.more_vert_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
