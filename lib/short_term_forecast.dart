import 'package:flutter/material.dart';

class ShortTermForecast extends StatefulWidget {
  @override
  _ShortTermForecastState createState() => _ShortTermForecastState();
}

class _ShortTermForecastState extends State<ShortTermForecast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predict Short Term Load Demand'),
      ),

    );
  }
}
