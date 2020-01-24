import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  String lable;
  double priceSpentOnDay;
  double totalPricePercentage;

  ChartBar(this.lable, this.priceSpentOnDay, this.totalPricePercentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraint) {
        return new Column(
          children: <Widget>[
            Container(
                height: constraint.maxHeight * 0.15,
                child: FittedBox(
                    child: Text("\$" + priceSpentOnDay.toStringAsFixed(0)))),
            SizedBox(
              height: constraint.maxHeight * 0.05,
            ),
            Container(
              height: constraint.maxHeight * 0.6,
              width: 10,
              child: new Stack(
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(220, 220, 220, 0.8),
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  new SizedBox(
                    height: constraint.maxHeight * 0.05,
                  ),
                  new FractionallySizedBox(
                    heightFactor: totalPricePercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(
              child: Text(lable),
              ),
            )
          ],
        );
      },
    );
  }
}
