import 'package:ai_notes/screens/Home.dart';
import 'package:ai_notes/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Build the appropriate page based on auth state
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Check if there is a valid session currectly
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return HomeScreen();
        } else {
          return Loginscreen();
        }
      },
    );
  }
}
