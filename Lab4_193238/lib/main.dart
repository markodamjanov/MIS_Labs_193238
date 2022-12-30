import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab4_193238/notificationservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

void main() {
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

class Term {
  late String name;
  late DateTime date;
  late String time;
  late String person;

  Term(this.name, this.date, this.time, this.person);
}

List<Term> termsList = [
  Term('Physics', DateTime.now(), '10 AM', 'Marko'),
  Term('Discrete Mathematics', DateTime(2022, 12, 21), '11 AM', 'Marko'),
  Term('Programming', DateTime(2022, 12, 21), '2 PM', 'Marko'),
];

final terms = [
  // {
  //   "name": 'Physics',
  //   "date": '15 Nov, 2022',
  //   "time": '08:00 AM',
  //   "person": "Marko"
  // },
  // {
  //   "name": 'Discrete Mathematics',
  //   "date": '20 Nov, 2022',
  //   "time": '10:00 AM',
  //   "person": "Marko"
  // },
];

class _MyHomePageState extends State<MyHomePage> {
  var textEditingController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();

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
    NotificationService().showNotification(1, "Terms", "Added a new term", 5);
    if (_name != "") {
      setState(() {
        terms.add({
          "name": _name,
          "date": DateFormat.yMMMd().format(_date),
          "time": _time.format(context),
          "person": emailLogged
        });
      });
      termsList.add(
        Term(_name, _date, _time.format(context), emailLogged),
      );
    }
    textEditingController.clear();
    _datePicked = false;
    _timePicked = false;
  }

  List<Term> _getEventsfromDay(DateTime date) {
    return termsList.where((element) => element.date.day == date.day).toList() ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
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
            : SingleChildScrollView( child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text(
                        "Welcome " + emailLogged,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        if (!isSameDay(selectedDay, selectDay)) {
                          setState(() {
                            selectedDay = selectDay;
                            focusedDay = focusDay;
                          });
                        }
                        print(focusedDay);
                      },
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },

                      eventLoader: (day) {
                        return _getEventsfromDay(day);
                      },

                      //To style the Calendar
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ..._getEventsfromDay(selectedDay).map(
                          (Term term) => Card(
                        child: ListTile(
                          title: Text(
                            "Term for: " +
                                term.person +
                                " \n" +
                                term.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${DateFormat.yMMMd().format(term.date)} - ${term.time}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
        ),
      ),
    );
  }

  Future isLoggedInOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailLogged = prefs.getString("email");
    var passwordLogged = prefs.getString("password");

    if (emailLogged != null && passwordLogged != null) {
      NotificationService().showNotification(1, "Login", "Logged In as " + emailLogged, 5);
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
            obscureText: true,
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
