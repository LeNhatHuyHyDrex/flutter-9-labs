import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const DicePage(),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 6;
  int rightDiceNumber = 4;
  final Random _random = Random();

  void rollDice() {
    setState(() {
      leftDiceNumber = _random.nextInt(6) + 1;
      rightDiceNumber = _random.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dice',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: rollDice,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Image.asset(
                    'assets/dice$leftDiceNumber.png',
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: rollDice,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Image.asset(
                    'assets/dice$rightDiceNumber.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
