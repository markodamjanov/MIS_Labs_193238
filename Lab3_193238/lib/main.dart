import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 - 193238',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lab3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var textEditingController = TextEditingController();

  String _name = "";
  DateTime _date = DateTime.now();
  TimeOfDay _time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  bool _datePicked = false;
  bool _timePicked = false;

  final terms = [
    {"name": 'Physics', "date": '15 Nov, 2022', "time": '08:00 AM'},
    {"name": 'Discrete Mathematics', "date": '20 Nov, 2022', "time": '10:00 AM'},
  ];

  void addTerm() {
    setState(() {
      terms.add({
        "name": _name,
        "date": DateFormat.yMMMd().format(_date),
        "time": _time.format(context)
      });
    });
    textEditingController.clear();
    _datePicked = false;
    _timePicked = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 - 193238',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lab3_193238'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('ADD'),
              onPressed: addTerm,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              )
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: TextField(
                controller: textEditingController,
                onChanged: (text) {
                  setState(() {
                    _name = text;
                  });
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter subject',
                ),
              ),
            ),
            Text(_datePicked ? DateFormat.yMMMd().format(_date) : 'Pick date'),
            ElevatedButton(
              child: Text(!_datePicked ? 'Pick a date' : 'Change date'),
              onPressed: () async {
                showDatePicker(
                        context: context,
                        initialDate: _date == null ? DateTime.now() : _date,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2023))
                    .then((date) {
                  setState(() {
                    _date = date!;
                    _datePicked = true;
                  });
                });
              },
            ),
            Text(_timePicked ? _time.format(context) : 'Pick time'),
            ElevatedButton(
              child: Text(!_timePicked ? 'Pick a time' : 'Change Time'),
              onPressed: () async {
                showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay(hour: _date.hour, minute: _date.minute))
                    .then((time) {
                  setState(() {
                    _time = time!;
                    _timePicked = true;
                  });
                });
                ;
              },
            ),
            Expanded(
                child: ListView.builder(
              itemCount: terms.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      terms[index]["name"]!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${terms[index]["date"]} - ${terms[index]["time"]}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
