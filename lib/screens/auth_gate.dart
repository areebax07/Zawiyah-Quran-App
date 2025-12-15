import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zawiyah/screens/homescreen.dart';
import 'package:zawiyah/screens/login_screen.dart';
import 'package:zawiyah/screens/signup_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showLoginScreen = true;

  void _toggleScreens() {
    setState(() {
      _showLoginScreen = !_showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return _showLoginScreen
            ? LoginScreen(showSignUpScreen: _toggleScreens)
            : SignUpScreen(showLoginScreen: _toggleScreens);
      },
    );
  }
}
