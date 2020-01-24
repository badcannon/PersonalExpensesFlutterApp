import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function poper;

  TransactionList(this.transactions, this.poper);

  @override
  Widget build(BuildContext context) {
    return transactions.length < 1
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return new Column(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.1,
                    child: Text(
                      "No transactions are avaliable",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Container(
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                    height: constraints.maxHeight * 0.6,
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                      child: ListTile(
                          leading: FittedBox(
                              child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            child: Text("\$${transactions[index].amount}"),
                          )),
                          title: Text(
                            "${transactions[index].title}",
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 18),
                          ),
                          subtitle: Text(DateFormat.yMMMd()
                              .format(transactions[index].date)),
                          trailing: MediaQuery.of(context).size.width > 460
                              ? FlatButton.icon(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  textColor: Theme.of(context).errorColor,
                                  label: Text("Delete"),
                                  onPressed: () {
                                    poper(transactions[index].id);
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    poper(transactions[index].id);
                                  },
                                ))));
            },
            itemCount: transactions.length,
          );
  }
}
