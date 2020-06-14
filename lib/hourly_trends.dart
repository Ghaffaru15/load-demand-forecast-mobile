import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'daily_trends.dart';

class HourlyTrends extends StatefulWidget {
  @override
  _HourlyTrendsState createState() => _HourlyTrendsState();
}

class _HourlyTrendsState extends State<HourlyTrends> {
  final format = DateFormat("yyyy-MM-dd");
  bool showSpinner;
  DateTime chosenDate;
//  List<charts.Series> _seriesLineData;
  List<charts.Series<HourlyPrediction, int>> _seriesLineData;
//  List<HourlyPrediction> hourlyPredictionData = [];
  var hourlyPredictionData = [];

  Future fetchHourlyPredictions() async {
    var date = DateTime.now();

    var response = await http.get(
        'https://load-demand-forecast.herokuapp.com/api/hourly/predictions/' +
            date.year.toString() +
            '/' +
            date.month.toString() +
            '/' +
            date.day.toString());

    List<HourlyPrediction> hourlyPredictionsData = [];
    var responseData = jsonDecode(response.body);
    for (var i = 0; i < jsonDecode(response.body)['hours'].length; i++) {
      hourlyPredictionsData.add(new HourlyPrediction(
          responseData['hours'][i].toInt(), responseData['predictions'][i]));
    }
    print(responseData);
    setState(() {
      hourlyPredictionData = hourlyPredictionsData;
    });

    print(hourlyPredictionData);

    var samplehourlyPredictionData = [
      new HourlyPrediction(1, 5),
      new HourlyPrediction(2, 4)
    ];
//    List<HourlyPrediction> hourlyPredictionData = [];
    setState(() {
      _seriesLineData.add(charts.Series<HourlyPrediction, int>(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
          id: 'Air Pollution',
          data: hourlyPredictionData,
          domainFn: (HourlyPrediction hourlyPrediction, _) =>
              hourlyPrediction.hour,
          measureFn: (HourlyPrediction hourlyPrediction, _) =>
              hourlyPrediction.prediction));
      showSpinner = false;
    });
    print(_seriesLineData);
  }

  Future getData() async {
    setState(() {
      showSpinner = true;
    });
    final http.Response response = await http.get(
        'https://load-demand-forecast.herokuapp.com/api/hourly/predictions/' +
            chosenDate.year.toString() +
            '/' +
            chosenDate.month.toString() +
            '/' +
            chosenDate.day.toString());

    print(response.body);

    List<HourlyPrediction> hourlyPredictionsData = [];
    var responseData = jsonDecode(response.body);
    for (var i = 0; i < jsonDecode(response.body)['hours'].length; i++) {
      hourlyPredictionsData.add(new HourlyPrediction(
          responseData['hours'][i].toInt(), responseData['predictions'][i]));
    }
    print(responseData);
    setState(() {
      hourlyPredictionData = hourlyPredictionsData;
    });

    setState(() {
      _seriesLineData = [];
      _seriesLineData.add(charts.Series<HourlyPrediction, int>(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
          id: 'Air Pollution',
          data: hourlyPredictionData,
          domainFn: (HourlyPrediction hourlyPrediction, _) =>
              hourlyPrediction.hour,
          measureFn: (HourlyPrediction hourlyPrediction, _) =>
              hourlyPrediction.prediction));

      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showSpinner = true;
    _seriesLineData = List<charts.Series<HourlyPrediction, int>>();
    fetchHourlyPredictions();
//    _generateData();
  }

  @override
  void didUpdateWidget(HourlyTrends oldWidget) {
    // TODO: implement didUpdateWidget
    _seriesLineData = List<charts.Series<HourlyPrediction, int>>();

    fetchHourlyPredictions();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Trends'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [

                  PopupMenuItem(
                      child: MaterialButton(
                          child: Text('Daily Trend'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DailyTrends()));
                          })),
                ];
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: _seriesLineData.length > 0
              ?
//        ListView(children: <Widget>[
//                DateTimeField(
//
//        ),
              Padding(
                  padding: EdgeInsets.all(8),
//        child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Select Day'),
                      DateTimeField(
                        onChanged: (DateTime value) {
                          setState(() {
                            chosenDate = value;
                          });

                          getData();
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
//                          fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: Colors.white,
                            )),
//                      style: TextStyle(color: Colors.white),
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            return date;
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Hourly Predictions today ' +
                            DateFormat.yMMMMEEEEd().format(DateTime.now()),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.LineChart(
                          _seriesLineData,
                          animate: true,
                          animationDuration: Duration(seconds: 2),
                          behaviors: [
                            new charts.ChartTitle('Hours',
                                behaviorPosition:
                                    charts.BehaviorPosition.bottom,
                                titleOutsideJustification:
                                    charts.OutsideJustification.middleDrawArea),
                            new charts.ChartTitle('Power',
                                behaviorPosition: charts.BehaviorPosition.start,
                                titleOutsideJustification:
                                    charts.OutsideJustification.middleDrawArea),
                          ],
                        ),
                      )
                    ],
                  ),
                )
//              ])
              : Center(
                  child: Text('No Data'),
                ),
        )
//      ),
        );
  }
}

class HourlyPrediction {
  int hour;
  double prediction;

  HourlyPrediction(this.hour, this.prediction);
}
