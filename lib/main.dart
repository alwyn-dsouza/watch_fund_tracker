// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:watch_fund_tracker/fund_details.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  /// The default is to dump the error to the console.
  /// Instead, a custom function is called.
  FlutterError.onError = (FlutterErrorDetails details) async {
    await _reportError(details);
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watch Fund Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double _currentFunds = 0.0;
  double _targetFunds = 0.0;
  double _weeklyContribution = 0.0;
  double _amountHundreds = 0.0;
  double _amountTens = 0.0;
  double _amountOnes = 0.0;
  double _weeksRemaining = 0;
  double _percentComplete = 0;
  double _enteredText = 0.0;
  Color _progressColor = Colors.red;

  FundDetails _db = FundDetails();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _db.init();
  }

  @override
  void dispose() {
    _db.disposed();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              children: <Widget>[
                Container(child: Image.asset('assets/images/WatchImage.PNG')),
                SizedBox(
                  width: 15.0,
                ),
                Text('Watch Fund Tracker',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0)),
              ],
            ),
          ),
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _showFundsWidget(),
            _addUpdateFundsWidget(),
            _weeksRemainingWidget(),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 200.0),
            StaggeredTile.extent(2, 200.0),
            StaggeredTile.extent(2, 150.0),
          ],
        ));
  }

  Widget _showFundsWidget() {
    return Container(
      child: FutureBuilder<List<Map>>(
          future: _db.getFundDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('_showFundsWidget Snapshot hasdata ${snapshot.hasData} ');
              print('_showFundsWidget Snapshot data ${snapshot.data} ');
              print(
                  '_showFundsWidget Snapshot data length ${snapshot.data.length} ');
              _currentFunds =
                  double.parse('${snapshot.data[0]['currentFunds']}');
              _targetFunds = double.parse('${snapshot.data[0]['targetFunds']}');
              _weeklyContribution =
                  double.parse('${snapshot.data[0]['weeklyContribution']}');
              if (_targetFunds > 0) {
                _percentComplete = _currentFunds / _targetFunds;
              } else {
                _percentComplete = 0.0;
              }

              if (_percentComplete < 0.0) {
                _percentComplete = 0;
                _progressColor = Colors.red;
              } else if (_percentComplete < 0.3) {
                _progressColor = Colors.red;
              } else if (_percentComplete < 0.6) {
                _progressColor = Colors.yellow;
              } else if (_percentComplete >= 1) {
                _percentComplete = 1;
                _progressColor = Colors.lightGreen;
              } else {
                _progressColor = Colors.green;
              }

              //_percentComplete = double.parse(_percentComplete.toStringAsFixed(2));

              return _buildTile(
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('Current Funds: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.0)),
                            Text('${snapshot.data[0]['currentFunds']}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.0)),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text('Target Funds: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.0)),
                            Text('${snapshot.data[0]['targetFunds']}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.0)),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 50,
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 30.0,
                          percent: _percentComplete,
                          //center: Text('${_percentComplete * 100} %'),
                          linearStrokeCap: LinearStrokeCap.butt,
                          progressColor: _progressColor,
                        ),
                      ]),
                ),
              );
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _addUpdateFundsWidget() {
    return _buildTile(
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(labelText: 'Enter Amount'),
                onChanged: (text) {
                  print("Enterered Amount: $text");
                  _enteredText = double.parse(text.toString());
                },
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _submitAddCurrentFunds(_enteredText);
                      });
                    },
                    child: const Text('Add'),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _submitSubtractCurrentFunds(_enteredText);
                      });
                    },
                    child: const Text('Subtract'),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _submitUpdateWeekly(_enteredText);
                      });
                    },
                    child: const Text('Update weekly'),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Widget _weeksRemainingWidget() {
    return Container(
      child: FutureBuilder<List<Map>>(
          future: _db.getFundDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(
                  '_weeksRemainingWidget Snapshot hasdata ${snapshot.hasData} ');
              print('_weeksRemainingWidget Snapshot data ${snapshot.data} ');
              print(
                  '_weeksRemainingWidget Snapshot data length ${snapshot.data.length} ');
              if (double.parse('${snapshot.data[0]['weeklyContribution']}') >
                  0.0) {
                _weeksRemaining = (double.parse(
                            '${snapshot.data[0]['targetFunds']}') -
                        double.parse('${snapshot.data[0]['currentFunds']}')) /
                    double.parse('${snapshot.data[0]['weeklyContribution']}');
                if (_weeksRemaining < 0) {
                  _weeksRemaining = 0;
                }

                return _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "You have ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                              TextSpan(
                                  text: "${_weeksRemaining.round()}",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25.0)),
                              TextSpan(
                                  text:
                                      " weeks remaining if you continue your contributions of ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                              TextSpan(
                                  text:
                                      "${snapshot.data[0]['weeklyContribution']}",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25.0)),
                              TextSpan(
                                  text: " per week.",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ]),
                          ),
                        ]),
                  ),
                );
              } else {
                return _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "Weekly contribution is currently set to 0. Please update your weekly contribution to get an estimate of how long it would take to reach your goal. ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ]),
                          ),
                        ]),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submitAddCurrentFunds(
    double _enteredText,
  ) {
    double _sum = _enteredText + _currentFunds;
    _db.values['my_fund_tracker_table']['id'] = 1;
    _db.values['my_fund_tracker_table']['currentFunds'] = '$_sum';
    _db.values['my_fund_tracker_table']['targetFunds'] = '$_targetFunds';
    _db.values['my_fund_tracker_table']['weeklyContribution'] =
        '$_weeklyContribution';
    _db.save('my_fund_tracker_table');
    _showSnackBar("Data saved successfully");
  }

  void _submitSubtractCurrentFunds(
    double _enteredText,
  ) {
    double _sum = _currentFunds - _enteredText;
    _db.values['my_fund_tracker_table']['id'] = 1;
    _db.values['my_fund_tracker_table']['currentFunds'] = '$_sum';
    _db.values['my_fund_tracker_table']['targetFunds'] = '$_targetFunds';
    _db.values['my_fund_tracker_table']['weeklyContribution'] =
        '$_weeklyContribution';
    _db.save('my_fund_tracker_table');
    _showSnackBar("Data saved successfully");
  }

  void _submitUpdateWeekly(double _enteredText) {
    _db.values['my_fund_tracker_table']['id'] = 1;
    _db.values['my_fund_tracker_table']['currentFunds'] = '$_currentFunds';
    _db.values['my_fund_tracker_table']['targetFunds'] = '$_targetFunds';
    _db.values['my_fund_tracker_table']['weeklyContribution'] = '$_enteredText';
    _db.save('my_fund_tracker_table');
    _showSnackBar("Data saved successfully");
  }
}

/// Reports [error] along with its [stackTrace]
Future<Null> _reportError(FlutterErrorDetails details) async {
  // details.exception, details.stack

  FlutterError.dumpErrorToConsole(details);
}
