import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate;

  void DisplayDatePicker() {
    showDatePicker(
            initialDate: DateTime.now(),
            context: context,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
        });
      }
    });
  }

  void submitData() {
    if (amountController.text.isEmpty ? false : double.parse(amountController.text) < 0) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    // As the addTx fucntion must be used in the State widget , rather than the widget it self
    // here the widget is constructed with the help of the state available , therefore we can access the function which is recived as an argument
    // in the constructor using the widget keyword !
    widget.addTx(enteredTitle, enteredAmount, selectedDate);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 50,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: (selectedDate == null
                              ? 'No Date Choosen'
                              : DateFormat.yMd().format(selectedDate)),
                        ),
                        autofocus: true,
                      ),
                    ),
                    new FlatButton(
                      child: Text("Choose Date"),
                      onPressed: DisplayDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                textColor: Colors.blueAccent,
                onPressed: submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
