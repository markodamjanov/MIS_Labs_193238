import 'package:flutter/material.dart';

import './clothes_question.dart';
import './clothes_answer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;

  var questions = [
    {
      'question':'Select clothing brand',
      'answer':[
        'Nike',
        'Adidas',
        'Louis Vuitton',
        'Gucci',
      ]
    },
    {
      'question':'Select clothing type',
      'answer':[
        'T-Shirt',
        'Shirt',
        'Jeans',
        'Trousers',
      ]
    },
    {
      'question':'Select clothing season',
      'answer':[
        'Winter',
        'Spring',
        'Summer',
        'Autumn',
      ]
    },
  ];

  void _iWasTapped(){
    setState(() {
      if(_questionIndex == 2) _questionIndex = 0;
      else _questionIndex += 1;
    });
    print("I was tapped");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 - 193238',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Lab2_193238"),
        ),
        body: Column(
          children: [
            ClothesQuestion(questions[_questionIndex]['question'] as String),
            ...(questions[_questionIndex]['answer'] as List<String>).map((answer) => ClothesAnswer(_iWasTapped, answer)),
          ]
        )
      )
    );
  }
}
