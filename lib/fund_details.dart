import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:watch_fund_tracker/sqllitedb.dart';

class FundDetails extends DBInterface {
  factory FundDetails() {
    if (_this == null) _this = FundDetails._getInstance();
    return _this;
  }

  /// Make only one instance of this class.
  static FundDetails _this;

  FundDetails._getInstance() : super();

  @override
  get name => 'FundDetails.db';

  @override
  get version => 1;

  @override
  Future onCreate(Database db, int version) async {
    await db.execute("""
     CREATE TABLE my_fund_tracker_table(
              id INTEGER PRIMARY KEY
              ,currentFunds TEXT
              ,targetFunds TEXT
              ,weeklyContribution TEXT
              )
     """);
    await db.execute("""
     insert into 
     my_fund_tracker_table(currentFunds,targetFunds, weeklyContribution) 
     values( "0","21075","0")              
     """);
    print('Table created ');
  }

  void save(String table) {
    saveRec(table);
  }

  Future<List<Map>> getFundDetails() async {
    return await this.rawQuery('SELECT * FROM my_fund_tracker_table');
  }
}
