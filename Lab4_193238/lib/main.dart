import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab4_193238/notificationservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
   NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - 193238',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lab4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final terms = [
  {"name": 'Physics', "date": '15 Nov, 2022', "time": '08:00 AM', "person": "Marko"},
  {
    "name": 'Discrete Mathematics',
    "date": '20 Nov, 2022',
    "time": '10:00 AM',
    "person": "Marko"
  },
];

class _MyHomePageState extends State<MyHomePage> {
  var textEditingController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  void initState() {
    isLoggedInOrNot().then((value) {});
    super.initState();
  }

  String _name = "";
  DateTime _date = DateTime.now();
  TimeOfDay _time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  bool _datePicked = false;
  bool _timePicked = false;
  bool _isLoggedIn = false;

  var emailLogged;

  void addTerm() {
    NotificationService().showNotification(1, "LoggedIn", "Login", 5);
    if(_name != "") {
      setState(() {
        terms.add({
          "name": _name,
          "date": DateFormat.yMMMd().format(_date),
          "time": _time.format(context),
          "person": emailLogged
        });
      });
    }
    textEditingController.clear();
    _datePicked = false;
    _timePicked = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - 193238',
      home: Scaffold(
        appBar: AppBar(
          title: Text(_isLoggedIn ? 'Lab4_193238' : "Login"),
          actions: <Widget>[
            _isLoggedIn
                ? ElevatedButton(
                    child: Text('ADD'),
                    onPressed: addTerm,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ))
                : Text(""),
            _isLoggedIn
                ? ElevatedButton(
                    child: Text('Logout'),
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.remove('email');
                      pref.remove('password');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return MyHomePage(title: "Lab4");
                      }));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ))
                : Text(""),
          ],
        ),
        body: !_isLoggedIn
            ? LoginPage()
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    child: Text(
                      "Welcome " + emailLogged,
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
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
                  Text(_datePicked
                      ? DateFormat.yMMMd().format(_date)
                      : 'Pick date'),
                  ElevatedButton(
                    child: Text(!_datePicked ? 'Pick a date' : 'Change date'),
                    onPressed: () async {
                      showDatePicker(
                              context: context,
                              initialDate:
                                  _date == null ? DateTime.now() : _date,
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
                              initialTime: TimeOfDay(
                                  hour: _date.hour, minute: _date.minute))
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
                            "Term for: " + terms[index]["person"]! + " \n" + terms[index]["name"]!,
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

  Future isLoggedInOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailLogged = prefs.getString("email");
    var passwordLogged = prefs.getString("password");

    if (emailLogged != null && passwordLogged != null) {
      NotificationService().showNotification(1, "LoggedIn", "Login", 5);
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
  }
}

class LoginPage extends StatelessWidget {
  var _email = "";
  var _password = "";
  var _error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: TextField(
            onChanged: (text) {
              _email = text;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: TextField(
            onChanged: (text) {
              _password = text;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter password',
            ),
          ),
        ),
        ElevatedButton(
            child: Text('Login'),
            onPressed: () async {
              if (_email.toString() == "" && _password.toString() == "") {
                _error = true;
              } else {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString("email", _email);
                pref.setString("password", _password);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return MyHomePage(title: "Lab4");
                }));
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child:
              Text(_error ? "Blank" : "", style: TextStyle(color: Colors.red)),
        ),
      ]),
    );
  }
}
