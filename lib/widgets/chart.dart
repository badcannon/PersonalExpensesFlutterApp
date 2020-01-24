import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

import './chart-bar.dart';

class Chart extends StatelessWidget {
  List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get GeneratedList {
    return List.generate(7, (index) {
      var WeekDay = DateTime.now().subtract(Duration(days: index));

      var TotalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == WeekDay.day &&
            recentTransaction[i].date.month == WeekDay.month &&
            recentTransaction[i].date.year == WeekDay.year) {
          TotalSum += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(WeekDay).substring(0, 2),
        'amount': TotalSum
      };
    });
  }

  double get totalSpending {
    return GeneratedList.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(6),
        // Only Padding ..
        child: Padding(
          padding: EdgeInsets.all(5),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ...GeneratedList.map((obj) {
                  return Flexible(
                      fit: FlexFit.tight,
                      child: new ChartBar(
                          obj['day'],
                          obj['amount'],
                          totalSpending == 0.0
                              ? 0.0
                              : (obj['amount'] as double) / totalSpending));
                }).toList(),
              ]),
        ));
  }
}
