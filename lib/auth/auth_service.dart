import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // sign in with email and password
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  // sign up with email and password
  Future<AuthResponse> signup(String email, String password) async {
    return await _supabase.auth.signUp(password: password, email: email);
  }

  // sign out
  Future<void> sighOut() async {
    await _supabase.auth.signOut();
  }

  // get user
  String? getUser() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
