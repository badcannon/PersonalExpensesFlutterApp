import 'package:flutter/material.dart';
import 'package:section4_app/models/transaction.dart';

class Budget extends StatelessWidget {
  final List<Transaction> userTransactions;
  final double MontlyBudget;
  final Function showModal;
  final BuildContext context0;
  Budget(this.MontlyBudget, this.userTransactions,this.showModal,this.context0);

 
  double get _TotalMoneySpentMontly {
     double _totalMoney = 0.0;
    userTransactions.forEach((tx) {
      if (tx.date.isAfter(DateTime.now().subtract(Duration(days: 30))) &&
          tx.date.isBefore(DateTime.now())) {
        _totalMoney += tx.amount;
      }
    });
    return _totalMoney;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                FittedBox(
                    child: Text(
                  "Monthly Budget",
                  style: Theme.of(context).textTheme.title,
                )),
                Row(
                  children: <Widget>[
                    Container(
                        width: constraints.maxWidth * 0.10,
                        child: FittedBox(
                            child: Text(
                                "\$" + _TotalMoneySpentMontly.toString()))),
                    Container(
                      width: constraints.maxWidth * .75,
                      height: 20,
                      child: new Stack(
                        children: <Widget>[
                          new Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(0, 0, 0, .8)),
                                color: Color.fromRGBO(0, 0, 0, .1)),
                          ),
                          FractionallySizedBox(
                            widthFactor: (_TotalMoneySpentMontly /( MontlyBudget)) > 1 ? 1 :_TotalMoneySpentMontly /( MontlyBudget),
                            child: new Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(0, 0, 0, .8)),
                                  color: (_TotalMoneySpentMontly / MontlyBudget) > 1 ? Theme.of(context).errorColor : Theme.of(context).primaryColor,
                            ),
                          )
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: constraints.maxWidth * .10,
                        child: FittedBox(
                            child: Text("\$" + MontlyBudget.toString()))),
                  ],
                ),
                FlatButton(child: Text("Edit"), onPressed: () {
                  showModal(this.context0);
                },)
              ],
            ),
          ),
        );
      },
    );
  }
}
