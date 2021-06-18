import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions,this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
            ? LayoutBuilder(builder: (ctx,constraint){
              return Column(children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: constraint.maxHeight*0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ]);
            })  
            : ListView(children: 
              transactions.map((tx) => TransactionItem(key: ValueKey(tx.id),transaction: tx, deleteTx: deleteTx)).toList()
            ,);
            // .builder(
            //     itemBuilder: (ctx, index) {
            //       return
                      // Card(
                      //       child: Row(children: <Widget>[
                      //     Container(
                      //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      //         decoration: BoxDecoration(
                      //             border: Border.all(
                      //                 color: Theme.of(context).primaryColor,
                      //                 width: 2,
                      //                 style: BorderStyle.solid)),
                      //         padding: EdgeInsets.all(10),
                      //         child: Text(
                      //           '\$${transactions[index].amount.toStringAsFixed(2)}',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 20,
                      //               color: Theme.of(context).primaryColor),
                      //         )),
                      //     Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           transactions[index].title,
                      //           style: Theme.of(context).textTheme.title,
                      //         ),
                      //         Text(
                      //           DateFormat.yMMMd().format(transactions[index].date),
                      //           style: TextStyle(color: Colors.grey),
                      //         )
                      //       ],
                      //     )
                      //       ]))
              //         TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
              //   },
              //   itemCount: transactions.length,
              // );
  }
}

