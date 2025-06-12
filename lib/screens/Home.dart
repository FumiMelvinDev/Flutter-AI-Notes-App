import 'package:ai_notes/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();

  void logout() async {
    await authService.sighOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconButton(onPressed: logout, icon: Icon(Icons.logout)),
    );
  }
}
