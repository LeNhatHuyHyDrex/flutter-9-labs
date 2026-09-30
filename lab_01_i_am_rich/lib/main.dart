import 'package:flutter/material.dart';

void main() {
  runApp(const IAmRichApp());
}

class IAmRichApp extends StatelessWidget {
  const IAmRichApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'I Am Rich',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'I Am Rich',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: Image(
            image: AssetImage('images/diamond.png'),
            width: 320,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
