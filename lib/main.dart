import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/tansaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Ств екземпляр та побудову наших віджетів
      title: 'My Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.amber),
        fontFamily: "AdventPro",
        primaryColor: Colors.purple,
        // ignore: deprecated_member_use
        accentColor: Colors.amber,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = []; //список транзакцій

  List<Transaction> get _recentTransactions {
    //нещодавні транзакції (в даному випадку за 7 днів)
    return _userTransaction.where((tx) {
      //(tx) - проходимо но кожному елементі
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7), //Повертає дні від (зараз - 7) тобто тиждень
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      DateTime.now().toString(), // id
      txTitle, //title
      txAmount, //price
      chosenDate, // date
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  } // _addTransaction

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      // ModalButton in AppBar
      context:
          ctx, // Вказуємо контекст (Використавується для пошуку (Навігація) контексту з яким ми працюємо)
      builder: (_) {
        // використовується для побудови відображення віджету при виклику нашого метода
        return NewTransaction(_addNewTransaction);
      },
    );
  } // _startAddNewTransaction

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id); //Видаляємо транзакцію зі списку звіряючи її ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Створює дизайн materialapp
      appBar: AppBar(
        title: Text(
          "Мої витрати",
        ),
        actions: [
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        // Щоб віджет можна було скролити
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),
            TransactionList(_userTransaction, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
