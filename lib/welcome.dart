// welcome_screen.dart
import 'package:flutter/material.dart';
import 'game_screen.dart';

class WelcomeScreen extends StatelessWidget {
  void _startGame(BuildContext context, int level) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(level: level)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IPv4 Quiz Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao Jogo de IPv4!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Nível 1: Endereços IPv4 /8, /16, /24'),
              onPressed: () => _startGame(context, 1),
            ),
            ElevatedButton(
              child: Text('Nível 2: Sub-redes (Máscara de Sub-rede Variável)'),
              onPressed: () => _startGame(context, 2),
            ),
            ElevatedButton(
              child: Text('Nível 3: Super-redes'),
              onPressed: () => _startGame(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}
