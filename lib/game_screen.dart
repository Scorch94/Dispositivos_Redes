import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'dart:math';

// Função para gerar um endereço IPv4 privado aleatório
String generateRandomIPv4() {
  final random = Random();
  int firstOctet = random.nextInt(3);
  String ip;
  if (firstOctet == 0) {
    // Faixa 10.0.0.0 - 10.255.255.255
    ip = '10.${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}';
  } else if (firstOctet == 1) {
    // Faixa 172.16.0.0 - 172.31.255.255
    ip = '172.${16 + random.nextInt(16)}.${random.nextInt(256)}.${random.nextInt(256)}';
  } else {
    // Faixa 192.168.0.0 - 192.168.255.255
    ip = '192.168.${random.nextInt(256)}.${random.nextInt(256)}';
  }
  return ip;
}

// Função para obter uma máscara aleatória para o Nível 1
String getRandomMask() {
  final random = Random();
  int maskType = random.nextInt(3);
  if (maskType == 0) {
    return "255.0.0.0"; // /8
  } else if (maskType == 1) {
    return "255.255.0.0"; // /16
  } else {
    return "255.255.255.0"; // /24
  }
}

// Função para obter uma máscara de sub-rede aleatória para o Nível 2
String getRandomSubnetMask() {
  final random = Random();
  List<String> subnetMasks = [
    "255.255.255.192", // /26
    "255.255.255.224", // /27
    "255.255.255.240", // /28
    "255.255.255.248", // /29
    "255.255.255.252", // /30
  ];
  return subnetMasks[random.nextInt(subnetMasks.length)];
}

// Função para obter uma máscara de super-rede para o Nível 3
String getSupernetMask() {
  final random = Random();
  List<String> supernetMasks = [
    "255.255.224.0", // /19
    "255.255.192.0", // /18
    "255.255.128.0", // /17
  ];
  return supernetMasks[random.nextInt(supernetMasks.length)];
}

// Função para calcular o Network ID
String calculateNetworkId(String ip, String mask) {
  List<int> ipOctets = ip.split('.').map(int.parse).toList();
  List<int> maskOctets = mask.split('.').map(int.parse).toList();
  List<int> networkIdOctets = List.generate(4, (i) => ipOctets[i] & maskOctets[i]);
  return networkIdOctets.join('.');
}

// Função para calcular o Broadcast Address
String calculateBroadcastAddress(String ip, String mask) {
  List<int> ipOctets = ip.split('.').map(int.parse).toList();
  List<int> maskOctets = mask.split('.').map(int.parse).toList();
  List<int> broadcastOctets = List.generate(4, (i) => ipOctets[i] | ~maskOctets[i] & 0xFF);
  return broadcastOctets.join('.');
}

// Funções para gerar perguntas
String generateNetworkIdQuestion(int level) {
  String ip = generateRandomIPv4();
  String mask = (level == 1) ? getRandomMask() : (level == 2) ? getRandomSubnetMask() : getSupernetMask();
  return "Qual é o Network ID para o endereço IP $ip com máscara $mask?";
}

String generateBroadcastAddressQuestion(int level) {
  String ip = generateRandomIPv4();
  String mask = (level == 1) ? getRandomMask() : (level == 2) ? getRandomSubnetMask() : getSupernetMask();
  return "Qual é o Broadcast Address para o endereço IP $ip com máscara $mask?";
}

// Função para verificar a resposta
bool checkAnswer(String question, String answer) {
  // Extraímos o IP e a máscara da pergunta
  RegExp regExp = RegExp(r'IP (\d+\.\d+\.\d+\.\d+) com máscara (\d+\.\d+\.\d+\.\d+)');
  Match? match = regExp.firstMatch(question);
  if (match != null) {
    String ip = match.group(1)!;
    String mask = match.group(2)!;
    if (question.contains("Network ID")) {
      return answer == calculateNetworkId(ip, mask);
    } else if (question.contains("Broadcast Address")) {
      return answer == calculateBroadcastAddress(ip, mask);
    }
  }
  return false;
}

class GameScreen extends StatefulWidget {
  final int level;

  GameScreen({required this.level});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _currentQuestion = '';
  String _answer = '';
  String _feedback = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      // Alterne entre Network ID e Broadcast Address
      int questionType = Random().nextInt(2);
      if (questionType == 0) {
        _currentQuestion = generateNetworkIdQuestion(widget.level);
      } else {
        _currentQuestion = generateBroadcastAddressQuestion(widget.level);
      }
      _feedback = '';
      _answer = '';
    });
  }

  void _checkAnswer() {
    setState(() {
      bool isCorrect = checkAnswer(_currentQuestion, _answer);
      if (isCorrect) {
        _score++;
        _feedback = 'Correto!';
      } else {
        _feedback = 'Incorreto. Tente novamente.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IPv4 Quiz Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentQuestion,
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              onChanged: (value) {
                _answer = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Verificar Resposta'),
              onPressed: _checkAnswer,
            ),
            SizedBox(height: 20),
            Text(_feedback),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Próxima Pergunta'),
              onPressed: _generateQuestion,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Ver Resultados'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen(score: _score)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
