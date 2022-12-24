import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 - 193238',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('193238 Марко Дамјанов'),
        ),
      ),
    );
  }
}
