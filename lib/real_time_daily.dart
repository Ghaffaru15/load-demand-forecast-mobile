import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'short_term_forecast.dart';
import 'real_time_hourly.dart';
import 'medium_term_forecast.dart';
import 'daily_trends.dart';
import 'developers.dart';

class RealTimeDaily extends StatefulWidget {
  @override
  _RealTimeDailyState createState() => _RealTimeDailyState();
}

class _RealTimeDailyState extends State<RealTimeDaily> {
  bool showSpinner;

  var now = DateTime.now();
  int humidity;
  double temperature;
  double pressure;

  double prediction;

  String _timeString;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future makePrediction() async {
    setState(() {
      showSpinner = true;
    });
    final http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=Ghana,sunyani&appid=e3311f6761891b3558c08b64e1a9bcf9');
    var temp = json.decode(response.body);

    setState(() {
      temperature = roundDouble((temp['main']['temp'] - 273.15), 2);
      humidity = temp['main']['humidity'];
      pressure = roundDouble(temp['main']['pressure'].toDouble(), 2);
    });

    var data = {
      "day": DateTime.now().day,
      "month": DateTime.now().month,
      "humidity": humidity,
      "temperature": temperature,
      "pressure": pressure
    };
    var jsonData = json.encode(data);

    final http.Response response2 = await http.post(
        'https://load-demand-forecast.herokuapp.com/api/predict/daily',
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonData);
    print(jsonData);
    print(response2.body);
    setState(() {
      prediction = roundDouble(
          double.parse(json.decode(response2.body)['prediction']), 2);
    });

    setState(() {
      showSpinner = false;
    });
//    print(temp['main']);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    print(showSpinner);
    makePrediction();
    Timer.periodic(Duration(minutes: 30), (Timer t) => makePrediction());
//    Timer.periodic(Duration(), callback)
    super.initState();
  }

  @override
  void didUpdateWidget(RealTimeDaily oldWidget) {
    // makePrediction();
    // Timer.periodic(Duration(minutes: 30), (Timer t) => makePrediction());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    var timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Color(0xFF1D1E33),
          child: ListView(
            children: <Widget>[
              createHeader(),
              SizedBox(
                height: 50,
              ),
              Divider(
                height: 10,
                color: Color(0xFF0A0E21),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Short Term Forecast',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ShortTermForecast()))
                },
              ),
              Divider(
                height: 10,
                color: Color(0xFF0A0E21),
              ),
              ListTile(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MediumTermForecast()))
                      },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          'Medium Term Forecast',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )),
              Divider(
                height: 10,
                color: Color(0xFF0A0E21),
              ),
//              ListTile(
//                  title: Row(
//                children: <Widget>[
//                  Icon(
//                    Icons.timer,
//                    color: Colors.white,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 25.0),
//                    child: Text(
//                      'Long Term Forecast',
//                      style: TextStyle(color: Colors.white),
//                    ),
//                  )
//                ],
//              )),
              Divider(
                height: 10,
                color: Color(0xFF0A0E21),
              ),
              ListTile(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DailyTrends()))
                },
                title: Row(
                  children: <Widget>[
                    Icon(
                        Icons.trending_up,
                        color:Colors.white
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text('Past Forecasts', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
              Divider(
                height: 10,
                color: Color(0xFF0A0E21),
              ),
              SizedBox(
                height: 50,
              ),
//              ListTile(
//                  onTap: () => {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (BuildContext context) =>
//                                Developers()))
//                  },
//                  title: Row(
//                children: <Widget>[
//                  Icon(
//                    Icons.people,
//                    color: Colors.white,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 25.0),
//                    child: Text(
//                      'Developers',
//                      style: TextStyle(color: Colors.white),
//                    ),
//                  )
//                ],
//              )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title:
            Text('Load Demand Forecast', style: TextStyle(color: Colors.white)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
//          color: Colors.red,
        child: prediction == null
            ? Text('')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Daily Forecast, Sunyani',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
//                              DateFormat.jm().format(DateTime.now()),
//                            _timeString != null ? _timeString : '',
                            '12:00 AM - 11:59 PM',
                            style: TextStyle(
                                color: Color(0xFF24D876),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            prediction != null ? prediction.toString() : '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 100.0,
                                color: Colors.white),
                          ),
                          Text(
                            'MegaWatt',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Load forecast today ' +
                                DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                                ' ',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              (MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RealTimeHourly())))
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'HOURLY FORECAST',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          color: Color(0xFFEB1555),
                          margin: EdgeInsets.only(top: 5.0),
                          width: size.width * 1,
                          height: 60.0,
                        ),
                      ),
//                      SizedBox(
//                        width: size.width * 0.06,
//                      ),
//                      GestureDetector(
//                        child: Container(
//                          child: Center(
//                            child: Text(
//                              'MONTHLY',
//                              style: TextStyle(
//                                  fontSize: 25.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.white),
//                            ),
//                          ),
//                          color: Color(0xFFEB1555),
//                          margin: EdgeInsets.only(top: 5.0),
//                          width: size.width * 0.49,
//                          height: 60.0,
//                        ),
//                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

Widget createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill, image: AssetImage('images/header.jpg'))),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("Machine Learning Predictions",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}
