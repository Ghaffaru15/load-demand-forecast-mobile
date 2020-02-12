import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool showSpinner = false;

  var now = DateTime.now();
  double humidity;
  double temperature;

  double prediction;

  Future fetchWeatherData() async {

    final http.Response response = await http.get('http://api.openweathermap.org/data/2.5/weather?q=Ghana,sunyani&appid=e3311f6761891b3558c08b64e1a9bcf9');
    print(response.statusCode);
  }
  Future predictHourly() async {
    var data = {
      "day": DateTime.now().day,
      "hour": DateTime.now().hour,
      "month": DateTime.now().month,
      "humidity": 23.12,
      "temperature": 12.44
    };
    var jsonData = json.encode(data);

    final http.Response response = await http.post('https://load-demand-forecast.herokuapp.com/api/predict/hourly',
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonData);

    print(response.body);
  }

  @override
  void initState() {

    showSpinner = true;
    predictHourly();
    fetchWeatherData();
    showSpinner = false;
    print(DateTime.now().day);
    super.initState();
  }

  @override
  void didUpdateWidget(MyApp oldWidget) {
    predictHourly();
//    print(DateTime.now().day);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xFF0A0E21),
          accentColor: Colors.purple,
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
      debugShowCheckedModeBanner: false,
      title: "hi",
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('Load Demand Forecast'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Hourly Forecast',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(15.0),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF1D1E33),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DateFormat.jm().format(DateTime.now()),
                        style: TextStyle(
                            color: Color(0xFF24D876),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '9.18',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 100.0),
                      ),
                      Text(
                        'MegaWatt',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Load forecast today ' +
                            DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                            ' ' +
                            DateFormat.jm().format(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child: Center(
                        child: Text(
                          'DAILY',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      color: Color(0xFFEB1555),
                      margin: EdgeInsets.only(top: 5.0),
                      width: 200,
                      height: 60.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: Container(
                      child: Center(
                        child: Text(
                          'MONTHLY',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      color: Color(0xFFEB1555),
                      margin: EdgeInsets.only(top: 5.0),
                      width: 190,
                      height: 60.0,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
