import 'package:flutter/material.dart';
import 'package:watch_fund_tracker/fund_data_model.dart';
import 'package:watch_fund_tracker/fund_details.dart';

class SettingsPage extends StatelessWidget {
  FundDataModel myData;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  FundDetails _db = FundDetails();
  bool _weeklyAutoDeposit = false;
  SettingsPage({Key key, @required this.myData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: new Center(
        child: _addUpdateFundsWidget(),
      ),
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
                  if (text != null)
                    myData.enteredText = double.parse(text.toString());
                  print("Enterered Amount: $text");
                  //_enteredText = double.parse(text.toString());
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              Column(
                children: <Widget>[
                  roundedRectButton(
                      "Update Weekly Contribution",
                      addFundsGradients,
                      false,
                      ButtonPressType.updateButtonType),
                  SizedBox(
                    width: 15.0,
                  ),
                  roundedRectButton("Update Target Funds", removeFundsGradients,
                      false, ButtonPressType.addButtonType),
                  SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Weekly Autodeposit'),
                value: (int.parse(myData.weeklyAutoDeposit.toString()) == 1)
                    ? true
                    : false,
                onChanged: (bool value) {
                  print("Changed flag");
                  _weeklyAutoDeposit = value;
                  _submitWeeklyAutoDeposit(_weeklyAutoDeposit);
                },
                secondary: const Icon(Icons.calendar_today),
              )
            ]),
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () => print('Not set yet'),
            child: child));
  }

  Widget roundedRectButton(String title, List<Color> gradient,
      bool isEndIconVisible, ButtonPressType whichButtonPressed) {
    return Builder(builder: (BuildContext mContext) {
      return GestureDetector(
        onTap: () {
          switch (whichButtonPressed) {
            case ButtonPressType.updateButtonType:
              {
                if (myData.enteredText >= 0)
                  _submitUpdateWeekly(myData.enteredText);
              }
              break;
            case ButtonPressType.addButtonType:
              {
                if (myData.enteredText >= 0)
                  _submitAddTarget(myData.enteredText);
              }
              break;
            default:
              print('Not set yet');
          }
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Stack(
              alignment: Alignment(1.0, 0.0),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(mContext).size.width / 1.0,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                ),
                Visibility(
                  visible: isEndIconVisible,
                  child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        (whichButtonPressed == ButtonPressType.addButtonType)
                            ? Icons.add
                            : Icons.remove,
                        size: 30,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static const List<Color> addFundsGradients = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];

  static const List<Color> removeFundsGradients = [
    Color(0xFFFF9945),
    Color(0xFFFc6076),
  ];

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submitUpdateWeekly(double _enteredText) {
    myData.weeklyContribution = _enteredText;
    String _myTargetFunds = myData.targetFunds.toString();
    String _myCurrentFunds = myData.currentFunds.toString();
    String _weeklyContribution = _enteredText.toString();
    int _weeklyAutoDeposit = (int.parse(myData.weeklyAutoDeposit.toString()));
    print("myData.targetFunds _submitUpdateWeekly: $_myTargetFunds");
    print("myData.mycurrentFunds _submitUpdateWeekly: $_myCurrentFunds");
    print(
        "myData.weeklyContribution _submitUpdateWeekly: $_weeklyContribution");
    print("myData.weeklyAutoDeposit _submitUpdateWeekly: $_weeklyAutoDeposit");
    _db.values['my_fund_tracker_table']['id'] = 1;
    _db.values['my_fund_tracker_table']['currentFunds'] = '$_myCurrentFunds';
    _db.values['my_fund_tracker_table']['targetFunds'] = '$_myTargetFunds';
    _db.values['my_fund_tracker_table']['weeklyContribution'] =
        '$_weeklyContribution';
    _db.values['my_fund_tracker_table']['weeklyAutoDeposit'] =
        '$_weeklyAutoDeposit';
    _db.save('my_fund_tracker_table');
    //   _showSnackBar("Data saved successfully");
  }

  void _submitAddTarget(double _enteredText) {
    myData.targetFunds = _enteredText;
    String _myTargetFunds = _enteredText.toString();
    String _myCurrentFunds = myData.currentFunds.toString();
    String _weeklyContribution = myData.weeklyContribution.toString();
    int _weeklyAutoDeposit = (int.parse(myData.weeklyAutoDeposit.toString()));
    print("myData.targetFunds _submitAddTarget: $_myTargetFunds");
    print("myData.mycurrentFunds_submitAddTarget: $_myCurrentFunds");
    print("myData.weeklyContribution _submitAddTarget: $_weeklyContribution");
    print("myData.weeklyAutoDeposit _submitUpdateWeekly: $_weeklyAutoDeposit");
    _db.values['my_fund_tracker_table']['id'] = 1;
    _db.values['my_fund_tracker_table']['currentFunds'] = '$_myCurrentFunds';
    _db.values['my_fund_tracker_table']['targetFunds'] = '$_myTargetFunds';
    _db.values['my_fund_tracker_table']['weeklyContribution'] =
        '$_weeklyContribution';
    _db.values['my_fund_tracker_table']['weeklyAutoDeposit'] =
        '$_weeklyAutoDeposit';
    _db.save('my_fund_tracker_table');
    //   _showSnackBar("Data saved successfully");
  }

  void _submitWeeklyAutoDeposit(bool _weeklyAutoDepositValue) {
    myData.weeklyAutoDeposit = (_weeklyAutoDepositValue) ? 1 : 0;
    String _myTargetFunds = myData.targetFunds.toString();
    String _myCurrentFunds = myData.currentFunds.toString();
    String _weeklyContribution = myData.weeklyContribution.toString();
    int _weeklyAutoDeposit = (_weeklyAutoDepositValue) ? 1 : 0;
    print("myData.targetFunds _submitWeeklyAutoDeposit: $_myTargetFunds");
    print("myData.mycurrentFunds _submitWeeklyAutoDeposit: $_myCurrentFunds");
    print(
        "myData.weeklyContribution _submitWeeklyAutoDeposit: $_weeklyContribution");
    print(
        "myData.weeklyAutoDeposit _submitWeeklyAutoDeposit: $_weeklyAutoDeposit");
    _db.values['my_fund_tracker_table']['id'] = 1;
    _db.values['my_fund_tracker_table']['currentFunds'] = '$_myCurrentFunds';
    _db.values['my_fund_tracker_table']['targetFunds'] = '$_myTargetFunds';
    _db.values['my_fund_tracker_table']['weeklyContribution'] =
        '$_weeklyContribution';
    _db.values['my_fund_tracker_table']['weeklyAutoDeposit'] =
        '$_weeklyAutoDeposit';
    _db.save('my_fund_tracker_table');
    //   _showSnackBar("Data saved successfully");
  }
}

enum ButtonPressType { addButtonType, subtractButtonType, updateButtonType }
