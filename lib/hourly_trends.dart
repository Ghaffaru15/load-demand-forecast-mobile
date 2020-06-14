import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'daily_trends.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
//      _seriesLineData.add(charts.Series<HourlyPrediction, int>(
//          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
//          id: 'Air Pollution',
//          data: hourlyPredictionData,
//          domainFn: (HourlyPrediction hourlyPrediction, _) =>
//              hourlyPrediction.hour,
//          measureFn: (HourlyPrediction hourlyPrediction, _) =>
//              hourlyPrediction.prediction));
//      _seriesLineData.add(ChartSeries<HourlyPrediction, int>(
//          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
//          id: 'Air Pollution',
//          data: hourlyPredictionData,
//          domainFn: (HourlyPrediction hourlyPrediction, _) =>
//          hourlyPrediction.hour,
//          measureFn: (HourlyPrediction hourlyPrediction, _) =>
//          hourlyPrediction.prediction));
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
          title: Text('Hourly Past Forecasts'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [

                  PopupMenuItem(
                      child: MaterialButton(
                          child: Text('Daily Past Forecasts'),
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
          child: hourlyPredictionData.length > 0
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
                          child: SfCartesianChart(

                            tooltipBehavior: TooltipBehavior(enable: true),
                              primaryXAxis: NumericAxis(
                                interval: 1,
                                visibleMinimum: 0,
                                visibleMaximum: 23,
                                title: AxisTitle(
                                  text: 'Time (Hours)',
                                ),

                              ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Power (MW)'
                              )
                            ),
                            series: <ChartSeries>[
                              LineSeries<HourlyPrediction, int>(
                                yAxisName: 'Power',
                                xAxisName: 'Hour',

                                enableTooltip: true,
                                dataSource: hourlyPredictionData,
                                xValueMapper: (HourlyPrediction prediction, _) => prediction.hour,
                                yValueMapper: (HourlyPrediction prediction, _) => prediction.prediction
                              )
                            ]
                          ),
//                        child: charts.LineChart(
//
//                          _seriesLineData,
//                          animate: true,
//                          domainAxis: new charts.NumericAxisSpec(
//                            tickProviderSpec: new charts.StaticNumericTickProviderSpec(
//                              <charts.TickSpec<num>>[
//                                charts.TickSpec<num>(0),
//                                charts.TickSpec<num>(1),
//
//                                charts.TickSpec<num>(2),
//                                charts.TickSpec<num>(3),
//                                charts.TickSpec<num>(4),
//                                charts.TickSpec<num>(5),
//                                charts.TickSpec<num>(6),
//                                charts.TickSpec<num>(7),
//                                charts.TickSpec<num>(8),
//                                charts.TickSpec<num>(9),
//                                charts.TickSpec<num>(10),
//                                charts.TickSpec<num>(11),
//                                charts.TickSpec<num>(12),
//                                charts.TickSpec<num>(13),
//                                charts.TickSpec<num>(14),
//                                charts.TickSpec<num>(15),
//                                charts.TickSpec<num>(16),
//                                charts.TickSpec<num>(17),
//                                charts.TickSpec<num>(18),
//                                charts.TickSpec<num>(19),
//                                charts.TickSpec<num>(20),
//                                charts.TickSpec<num>(21),
//                                charts.TickSpec<num>(22),
//                                charts.TickSpec<num>(23),
////                                charts.TickSpec<num>(24)
//                              ],
//                            ),
//                          ),
//                          animationDuration: Duration(seconds: 2),
//                          defaultRenderer: new charts.LineRendererConfig(includePoints: true),
//                          behaviors: [
//
//                            new charts.ChartTitle('Hours',
//
//
//                                behaviorPosition:
//                                    charts.BehaviorPosition.bottom,
//                                titleOutsideJustification:
//                                    charts.OutsideJustification.middleDrawArea,
//                            ),
//                            new charts.ChartTitle('Power',
//                                behaviorPosition: charts.BehaviorPosition.start,
//                                titleOutsideJustification:
//                                    charts.OutsideJustification.middleDrawArea),
//                            new charts.LinePointHighlighter(
//                                showHorizontalFollowLine:
//                                charts.LinePointHighlighterFollowLineType.none,
//                                showVerticalFollowLine:
//                                charts.LinePointHighlighterFollowLineType.nearest),
//                            // Optional - By default, select nearest is configured to trigger
//                            // with tap so that a user can have pan/zoom behavior and line point
//                            // highlighter. Changing the trigger to tap and drag allows the
//                            // highlighter to follow the dragging gesture but it is not
//                            // recommended to be used when pan/zoom behavior is enabled.
//                            new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag)
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

class HourlyPrediction {
  int hour;
  double prediction;

  HourlyPrediction(this.hour, this.prediction);
}
