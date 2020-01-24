import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:section4_app/widgets/budget.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        accentColor: Colors.lightGreen,
        fontFamily: "StoneWalls",
        // The Global Text theme:
        textTheme: GoogleFonts.madaTextTheme(Theme.of(context).textTheme),
        // AppBar theme :
        appBarTheme: AppBarTheme(
            textTheme: GoogleFonts.manjariTextTheme(
          Theme.of(context)
              .textTheme
              .copyWith(title: TextStyle(color: Colors.white, fontSize: 30)),
        )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 122,
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 123,
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];

  double _monthlyBudget = 1000;
  bool _showChart = false;
  var _monthlyBudgetController = TextEditingController() ;

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: Random(((DateTime.now().hour +
                              DateTime.now().second +
                              DateTime.now().minute) /
                          _userTransactions.length ==
                      0
                  ? 1
                  : _userTransactions.length)
              .round())
          .nextInt(32600),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      // This is to indicate in which context the modal window must open
      context: ctx,
      // this is the builder fucntion : it gives another context object which we dont need so we use _ to ignore
      builder: (_) {
        return new NewTransaction(_addNewTransaction);
      },
    );
  }

  void monthlyBudgetchange(){
    var BudgetMoney = double.parse(_monthlyBudgetController.text);
    setState(() {
      _monthlyBudget = BudgetMoney;
    });
    Navigator.of(context).pop();
  }

  void _showMonthModal(BuildContext ctx ){
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_){
        return Container(
          height: MediaQuery.of(context).viewInsets.bottom + 200,
            child: new Card(
            child: Column(
              children: <Widget>[
                
                TextField(controller: _monthlyBudgetController,decoration: InputDecoration(
                  labelText: "Budget"
                ),),
                FlatButton(child: Text("Submit"), onPressed: (){
                  monthlyBudgetchange();
                },)
              ],
            ),

          ),
        );
      }
    );

  }

  void _poper(int Id) {
    print(Id);
    setState(() {
      _userTransactions.removeWhere((trans) {
        if (trans.id == Id) {
          return true;
        } else {
          return false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = Orientation.landscape == mediaQuery.orientation;

    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: GestureDetector(
              onTap: () {
                _startAddNewTransaction(context);
              },
              child: Icon(CupertinoIcons.add),
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appbar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Show Chart",
                      style: TextStyle(fontSize: 15),
                    ),
                    Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart == false
                              ? _showChart = true
                              : _showChart = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (isLandscape)
              _showChart == true
                  ? Container(
                      height: ((mediaQuery.size.height -
                              appbar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.5),
                      child: Chart(_recentTransaction))
                  : Container(
                      child: TransactionList(_userTransactions, _poper),
                      height: (mediaQuery.size.height -
                              appbar.preferredSize.height -
                              mediaQuery.padding.top) *
                          .6,
                    ),
            if (!isLandscape)
              Container(
                  height: ((mediaQuery.size.height -
                          appbar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3),
                  child: Chart(_recentTransaction)),
            if (!isLandscape)
              Container(  
                padding: EdgeInsets.all(2),
                height: (mediaQuery.size.height -
                        appbar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.23,
                width: mediaQuery.size.width,
                child: new Budget(_monthlyBudget, _userTransactions,_showMonthModal,context),
              ),
            if (!isLandscape)
              Container(
                child: TransactionList(_userTransactions, _poper),
                height: (mediaQuery.size.height -
                        appbar.preferredSize.height -
                        mediaQuery.padding.top) *
                    .4,
              ),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appbar,
          )
        : Scaffold(
            appBar: appbar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isAndroid
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  )
                : Container());
  }
}
