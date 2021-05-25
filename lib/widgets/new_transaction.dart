import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  final Function addToTransactions;
  NewTransaction(this.addToTransactions);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData(){
    final enteredTitle = titleController.text;
    final enteredAmount= double.parse(amountController.text);

      if(enteredTitle.isEmpty || enteredAmount <=0){
          return;
      }
      widget.addToTransactions(enteredTitle,enteredAmount);
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
            Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Expense Title'),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Expense Amount'),
            controller: amountController,
            // onSubmitted: (_) => submitData(),
          ),
          FlatButton(
            child: Text('Add Transaction'),
            textColor: Colors.purple,
            onPressed: () {
              submitData();
            },
          )
        ]),
      ),
    );
  }
}
