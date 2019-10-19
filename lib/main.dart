import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _value1 = false;
  String _timeString;
  int id;

  void _onChanged1(bool value) => setState(() => _value1 = value);

  @override
  void initState() {
    // TODO: implement initState
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    id = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistik"),
        leading: IconButton(
          icon: Icon(Icons.book, color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: <Widget>[
                  Text(
                    _timeString,
                    style: TextStyle(fontSize: 21),
                  ),
                  Divider(),
                  Text(
                    "Data : $id",
                    style: TextStyle(fontSize: 21),
                  ),
                ],
              )
            ),
            Divider(),
            Container(
                padding: EdgeInsets.only(bottom: 25),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Keluar"),
                    Switch(value: _value1, onChanged: _onChanged1),
                    Text("Masuk")
                  ],
                )),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 300,
                    height: 100,
                    child: RaisedButton(
                      child: Text(
                        "Plat N",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        String str;
                        if (_value1 == false) {
                          _save(dt: _timeString, dir: "Plat N", p: "Keluar");
                          str = '$_timeString, Plat N, Keluar\n';
                        } else {
                          _save(dt: _timeString, dir: "Plat N", p: "Masuk");
                          str = '$_timeString, Plat N, Masuk\n';
                        }
                        print(str);
                      },
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  ButtonTheme(
                    minWidth: 300,
                    height: 100,
                    child: RaisedButton(
                      child: Text(
                        "Plat Non N",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () async {
                        String str;
                        if (_value1 == false) {
                          _save(dt: _timeString, dir: "Plat Non-N", p: "Keluar");
                          str = '$_timeString, Plat Non-N, Keluar\n';
                        } else {
                          _save(dt: _timeString, dir: "Plat Non-N", p: "Masuk");
                          str = '$_timeString, Plat Non-N, Masuk\n';
                        }
                        print(str);
                        },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _save({@required String dt, @required String dir, @required String p}) async {
    Word word = Word();
    word.date_time = dt;
    word.direction = dir;
    word.plat = p;
    DatabaseHelper helper = DatabaseHelper.instance;
    this.id = await helper.insert(word);
    print('inserted row: $id');
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  void exportDB() {

  }
}
