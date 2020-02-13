import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class ShortTermForecast extends StatefulWidget {
  @override
  _ShortTermForecastState createState() => _ShortTermForecastState();
}

class _ShortTermForecastState extends State<ShortTermForecast> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  DateTime chosenDate;

  String humidity;

  String temperature;

  double prediction;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void submit() async {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();
    setState(() {
      showSpinner = true;
    });
    final Map<String, dynamic> data = {
      "day": chosenDate.day,
      "hour": chosenDate.hour,
      "month": chosenDate.month,
      "humidity": double.parse(humidity),
      "temperature": double.parse(temperature),
    };

    var jsonData = json.encode(data);

    print(jsonData);

    final http.Response response = await http.post(
        'https://load-demand-forecast.herokuapp.com/api/predict/hourly',
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonData);

    print(response.body);

    setState(() {
      prediction = roundDouble(
          double.parse(json.decode(response.body)['prediction']), 2);
    });

    setState(() {
      showSpinner = false;
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Load demand at this hour'),
            content: Text(
              '$prediction MW',
              style: TextStyle(fontSize: 40),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1E33),
//      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Predict Short Term Load Demand'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(padding: EdgeInsets.all(24), children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Select Date to Forecast',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                DateTimeField(
                  onSaved: (DateTime value) {
                    setState(() {
                      chosenDate = value;
                    });
                  },
                  validator: (DateTime value) {
                    if (value == null) {
                      return 'The date field is required';
                    }
//                  return value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hoverColor: Colors.white,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      )),
                  style: TextStyle(color: Colors.white),
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Provide Humidity Value ( % )',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (String value) {
                    setState(() {
                      humidity = value;
                    });
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'The humidity field is required';
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.confirmation_number,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Provide Temperature Value ( C )',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (String value) {
                    setState(() {
                      temperature = value;
                    });
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'The temperature field is required';
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                      prefixIcon:
                          Icon(Icons.confirmation_number, color: Colors.white),
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
//                    color: Colors.white,
                      onPressed: submit,
                      child: Text(
                        'PREDICT',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
