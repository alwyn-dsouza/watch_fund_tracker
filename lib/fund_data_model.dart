import 'package:flutter/material.dart';

class FundDataModel {
  double currentFunds;
  double targetFunds;
  double weeklyContribution;
  double weeksRemaining;
  double percentComplete;
  double enteredText;
  Color progressColor;
  int weeklyAutoDeposit;

  FundDataModel(
      this.currentFunds,
      this.targetFunds,
      this.weeklyContribution,
      this.weeksRemaining,
      this.percentComplete,
      this.enteredText,
      this.progressColor,
      this.weeklyAutoDeposit);
}
