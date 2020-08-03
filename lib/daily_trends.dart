import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'hourly_trends.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DailyTrends extends StatefulWidget {
  final DateTime initialDate = DateTime.now();
//  const DailyTrends({Key key, @required this.initialDate }) : super(key: key);
  @override
  _DailyTrendsState createState() => _DailyTrendsState();
}

class _DailyTrendsState extends State<DailyTrends> {

  DateTime selectedDate;


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final format = DateFormat("yyyy-MM");
  bool showSpinner;
  DateTime chosenDate = DateTime.now();
//  List<charts.Series> _seriesLineData;
  List<charts.Series<DailyPrediction, int>> _seriesLineData;
//  List<HourlyPrediction> hourlyPredictionData = [];
  var dailyPredictiondata = [];

  Future fetchDailyPredictions() async {
    var date = DateTime.now();

    var response = await http.get(
        'https://load-demand-forecast.herokuapp.com/api/daily/predictions/' +
            date.year.toString() +
            '/' +
            date.month.toString());

    List<DailyPrediction> dailyPredictionsData = [];
    var responseData = jsonDecode(response.body);
    for (var i = 0; i < jsonDecode(response.body)['days'].length; i++) {
      dailyPredictionsData.add(new DailyPrediction(
          responseData['days'][i].toInt(), responseData['predictions'][i]));
    }
//    print(responseData);
    setState(() {
      dailyPredictiondata = dailyPredictionsData;
    });

    print(dailyPredictiondata);

//    List<HourlyPrediction> hourlyPredictionData = [];
    setState(() {
      _seriesLineData.add(charts.Series<DailyPrediction, int>(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
          id: 'Air Pollution',
          data: dailyPredictiondata,
          domainFn: (DailyPrediction hourlyPrediction, _) =>
              hourlyPrediction.day,
          measureFn: (DailyPrediction hourlyPrediction, _) =>
              hourlyPrediction.prediction));
      showSpinner = false;
    });
//    print(_seriesLineData);
  }

  Future getData() async {
    setState(() {
      showSpinner = true;
    });

    if (selectedDate == null) {
      setState(() {
        selectedDate = DateTime.now();
      });
    }
    final http.Response response = await http.get(
        'https://load-demand-forecast.herokuapp.com/api/daily/predictions/' +
            selectedDate.year.toString() +
            '/' +
            selectedDate.month.toString());

    print(response.body);

    List<DailyPrediction> dailyPredictionsData = [];
    var responseData = jsonDecode(response.body);
    for (var i = 0; i < jsonDecode(response.body)['days'].length; i++) {
      dailyPredictionsData.add(new DailyPrediction(
          responseData['days'][i].toInt(), responseData['predictions'][i]));
    }
    print(responseData);
    setState(() {
      dailyPredictiondata = dailyPredictionsData;
    });

    setState(() {
      _seriesLineData = [];
      _seriesLineData.add(charts.Series<DailyPrediction, int>(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
          id: 'Air Pollution',
          data: dailyPredictiondata,
          domainFn: (DailyPrediction hourlyPrediction, _) =>
              hourlyPrediction.day,
          measureFn: (DailyPrediction hourlyPrediction, _) =>
              hourlyPrediction.prediction));

      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showSpinner = true;

    _seriesLineData = List<charts.Series<DailyPrediction, int>>();
    fetchDailyPredictions();
    selectedDate = DateTime.now();
//    _generateData();
  }

  @override
  void didUpdateWidget(DailyTrends oldWidget) {
    // TODO: implement didUpdateWidget
    _seriesLineData = List<charts.Series<DailyPrediction, int>>();

    fetchDailyPredictions();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Daily Past Forecasts'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
//                  PopupMenuItem(child: Text(''),),
                  PopupMenuItem(
                      child: MaterialButton(
                          child: Text('Hourly Past Forecasts'), onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HourlyTrends()));
                      })),
                ];
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: dailyPredictiondata.length > 0
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
//                      Text('Select Month'),
                      RaisedButton(
                        onPressed: () {
                          showMonthPicker(
                              context: context,
//                              firstDate: DateTime( DateTime.now().year - 1 , 5),
//                              lastDate: DateTime( DateTime.now().year + 1, 9 ),
                                firstDate: DateTime(2020,3),
                                lastDate: DateTime.now(),
                              initialDate: selectedDate ?? widget.initialDate
                          )
                              .then((date) => setState(() {
                            selectedDate = date;
                            getData();
                          })
//
                          );

                        },
                        child: Text('Select Month'),
                      ),
//                      DateTimeField(
//
//                        onChanged: (DateTime value) {
//                          setState(() {
//                            chosenDate = value;
//                          });
//
//                          getData();
//                        },
//                        validator: (DateTime value) {
//                          if (value == null) {
//                            return 'The date field is required';
//                          }
////                  return value;
//                        },
//                        decoration: InputDecoration(
//                            border: OutlineInputBorder(),
//                            hoverColor: Colors.white,
////                          fillColor: Colors.white,
//                            prefixIcon: Icon(
//                              Icons.date_range,
//                              color: Colors.white,
//                            )),
////                      style: TextStyle(color: Colors.white),
//                        format: format,
//                        onShowPicker: (context, currentValue) async {
//                          final date = await showDatePicker(
//                              context: context,
//                              firstDate: DateTime(1900),
//                              initialDate: DateTime.now(),
//                              lastDate: DateTime(2100));
//                          if (date != null) {
//                            return date;
//                          } else {
//                            return currentValue;
//                          }
//                        },
//                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Daily Predictions for the month of ' +
                            DateFormat.yMMMM().format(selectedDate),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SfCartesianChart(

                            tooltipBehavior: TooltipBehavior(enable: true),
                            primaryXAxis: NumericAxis(
                              interval: 1,
                              visibleMinimum: 1,
                              visibleMaximum: 31,
                              title: AxisTitle(
                                text: 'Time (Day)',
                              ),

                            ),
                            primaryYAxis: NumericAxis(
                                title: AxisTitle(
                                    text: 'Power (MW)'
                                )
                            ),
                            series: <ChartSeries>[
                              LineSeries<DailyPrediction, int>(
                                  yAxisName: 'Power',
                                  xAxisName: 'Day',

                                  enableTooltip: true,
                                  dataSource: dailyPredictiondata,
                                  xValueMapper: (DailyPrediction prediction, _) => prediction.day,
                                  yValueMapper: (DailyPrediction prediction, _) => prediction.prediction
                              )
                            ]
                        ),
//                        child: charts.LineChart(
//                          _seriesLineData,
//                          animate: true,
//                          animationDuration: Duration(seconds: 2),
//                          behaviors: [
//                            new charts.ChartTitle('Days',
//                                behaviorPosition:
//                                    charts.BehaviorPosition.bottom,
//                                titleOutsideJustification:
//                                    charts.OutsideJustification.middleDrawArea),
//                            new charts.ChartTitle('Power',
//                                behaviorPosition: charts.BehaviorPosition.start,
//                                titleOutsideJustification:
//                                    charts.OutsideJustification.middleDrawArea),
//                          ],
//                        ),
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

class DailyPrediction {
  int day;
  double prediction;

  DailyPrediction(this.day, this.prediction);
}
