import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expenses_app/widgets/chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
//import './widgets/user_transaction.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // Platform.isIOS ? CupertinoApp(
        //   title: 'Personal Expenses',
        //   debugShowCheckedModeBanner: false,
        //   theme: CupertinoThemeData(
        //       primarySwatch: Colors.purple,
        //       accentColor: Colors.amber,
        //       fontFamily: 'Quicksand',
        //       textTheme: ThemeData.light().textTheme.copyWith(
        //           title: TextStyle(
        //               fontFamily: 'OpenSans',
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold),
        //           button: TextStyle(color: Colors.white)),
        //       appBarTheme: AppBarTheme(
        //           textTheme: ThemeData.light().textTheme.copyWith(
        //               title: TextStyle(
        //                   fontFamily: 'OpenSans',
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.bold)))),
        //   home: MyHomePage(),
        // ):
        MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 35.25,
    //     date: DateTime.now())
  ];

  bool _showChart = false;

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
  }
  @override
  dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: choosenDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  Widget _buildAndroidAppBar(){
    return AppBar(
            title: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'Open Sans'),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    _startAddNewTransaction(context);
                  },
                  icon: Icon(Icons.add))
            ],
          );
  }

  Widget _buildIOSAppBar(){
    return CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'Open Sans'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () {
                    _startAddNewTransaction(context);
                  },
                )
              ],
            ),
          );
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text('Show Chart', style: Theme.of(context).textTheme.title),
      Switch.adaptive(
        activeColor: Theme.of(context).accentColor,
        value: _showChart,
        onChanged: (val) {
          setState(() {
            _showChart = val;
          });
        },
      ),
    ]),  _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txListWidget];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.25,
        child: Chart(_recentTransactions)), txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildIOSAppBar()
        : _buildAndroidAppBar();

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.75,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar,txListWidget),
            if (!isLandscape) ..._buildPortraitContent(mediaQuery, appBar,txListWidget),
            
          ]),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
          );
  }
}
