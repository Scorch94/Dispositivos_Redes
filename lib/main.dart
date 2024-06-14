// main.dart
import 'package:flutter/material.dart';
import 'welcome.dart';

void main() {
  runApp(Dispositivos_Redes());
}

class Dispositivos_Redes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPv4 Quiz Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
