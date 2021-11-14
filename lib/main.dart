import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/tansaction.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('uk'),
        const Locale('us'),
      ],
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
  bool _showChart = false;

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
      _userTransaction.add(newTx); //Додаємо транзакцію
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
      _userTransaction.removeWhere(
          (tx) => tx.id == id); //Видаляємо транзакцію зі списку звіряючи її ID
    });
  }

  List _buildLandscapeContent(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    // віджет, який відображатиме контент в альбомному режимі
    return [
      Row(
        //Якщо альбомний режим тоді відображати цей віджет
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Відображати діаграму'),
          Switch.adaptive(
            //Кнопка переключення
            value: _showChart, //true or false
            onChanged: (bool val) {
              setState(() {
                _showChart = val; //при перемиканні змінюємо наш State
              });
            },
          ),
        ],
      ),
      _showChart // Це змінна за допомогою якої при зміні значення ми відображаємо Діаграму чи пранзакції в альбомному відображенні
          // if false
          ? Container(
              height: (mediaQuery.size
                          .height - //Беремо всю висоту і віднімаємо висоту аппБару + лінії статусу (зверху)
                      appBar.preferredSize
                          .height - // Отримуємо дані аппБару за допомогою preferredSize
                      mediaQuery
                          .padding.top) * // Забираємо нашу лінію статусу зверху
                  0.7, // відношення у відсотках щодо висоти
              child: Chart(_recentTransactions))
          // if true
          : txListWidget //Присвоїна змінна віджету, оскільки ми оперуємо ним в декількох місьцях (насправді це хардкод, але в даному випадку це єдине рішення)
    ];
  }

  List _buildPortraitContent(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    // Якщо ми не в альбомному режимі то відображати віджети будемо так;
    return [
      Container(
        height: (mediaQuery.size
                    .height - //Беремо всю висоту і віднімаємо висоту аппБару + лінії статусу (зверху)
                appBar.preferredSize
                    .height - // Отримуємо дані аппБару за допомогою preferredSize
                mediaQuery.padding.top) * // Забираємо нашу лінію статусу зверху
            0.3, // відношення у відсотках щодо висоти
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              "Мої витрати",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, //зменшення аппбару
              children: [
                GestureDetector(
                  // '+' в аппбарі на ios
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ))
        : AppBar(
            //Присвоюємо змінну щоб ми могли отримати дані про висоту, яку займає аппБар
            title: Text(
              "Мої витрати",
            ),
            actions: [
              // Те що є в appBar
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              ),
            ],
          )) as PreferredSizeWidget;
  }

  @override // пояснюємо що це не помилка, а ми робимо це наміренно або це розширення класу
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation ==
        Orientation.landscape; //Якщо наш гаджет в альбомному режимі
    final PreferredSizeWidget appBar = _buildAppBar(); // Метод побудови коду (чистий код та легкий для читання не зважаючи, що його не зменшилось)
    final txListWidget = Container(
        // Transactions List
        height: (mediaQuery.size
                    .height - //MediaQuery - дозволяє отримати інформацію про орієнтацію пристрою, заходи, налаштування користувача тощо.
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.75,
        child: TransactionList(_userTransaction, _deleteTransaction));
    final pageBody = SafeArea(
      //SafeArea - віджет, який задає дочірньому елементи відступи, щоб уникнути пересікання з зарезервованими місцями (такі як статус бар і т.д)
      //Перенесли тіло в цю змінну щоб не дублювати код для ІОS/Android
      child: SingleChildScrollView(
        // Щоб віджет можна було скролити
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                ..._buildLandscapeContent(
                  mediaQuery,
                  appBar,
                  txListWidget,
                ), //потрібні дужки, щоб Дарт розумів, що при цій умові треба відобразити цей віджет
              if (!isLandscape)
                ..._buildPortraitContent(
                  // ... - спретовий оператор -- ми витягуємо всі елементи списку та об'єднюємо їх, як окремі елементи
                  mediaQuery,
                  appBar,
                  txListWidget,
                ),
            ]),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            // Створює дизайн materialapp
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ), //Плаваюча пнопка (в даному випадку це '+' знизу)
          );
  }
}