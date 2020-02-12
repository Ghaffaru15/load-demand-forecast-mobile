import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF0A0E21),
        accentColor: Colors.purple,
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        textTheme: TextTheme(body1: TextStyle(color: Colors.white))
      ),
      debugShowCheckedModeBanner: false,
      title: "hi",
      home: Scaffold(
        appBar: AppBar(
          title: Text('Load Demand Forecast'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(15.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
