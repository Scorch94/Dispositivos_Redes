import 'package:flutter/material.dart';
import 'welcome.dart';
import 'login.dart';
import 'register.dart';
import 'game_screen.dart';

void main() {
  runApp(IPv4QuizGameApp());
}

class IPv4QuizGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPv4 Quiz Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/welcome': (context) => WelcomeScreen(),
        '/register': (context) => RegisterPage(),
        '/game': (context) => GameScreen(level: 1),
      },
    );
  }
}
