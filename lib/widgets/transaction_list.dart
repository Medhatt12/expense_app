import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions,this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 550,
        child: transactions.isEmpty
            ? Column(children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ])
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return
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
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal:5),
                                              child: ListTile(
                    leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                            padding: EdgeInsets.all(6),
                            child: FittedBox(
                                child: Text('\$${transactions[index].amount}'))),
                    ),
                    title: Text(transactions[index].title, style: Theme.of(context).textTheme.title),
                    subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
                    trailing: IconButton(onPressed: () => deleteTx(transactions[index].id), icon: Icon(Icons.delete), color: Theme.of(context).errorColor,),
                  ),
                      );
                },
                itemCount: transactions.length,
              ));
  }
}
