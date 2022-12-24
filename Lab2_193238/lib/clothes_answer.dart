import 'package:flutter/material.dart';

class ClothesAnswer extends StatelessWidget {
  String answerText;
  final VoidCallback? tapped;
  ClothesAnswer(this.tapped, this.answerText);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: tapped,
      child: Text(answerText,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        foregroundColor: MaterialStateProperty.all(Colors.red),
      ),
    );

  }
}