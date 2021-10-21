import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController(); //контролер приймає в
  final _amountController =
      TextEditingController(); //                   себе дані, які ми вводимо
  DateTime _selectedDate =
      DateTime.now(); // Дата, яка викор при додаванні транзації

  void _submitData() {
    // прийняття даних транзакції
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return; // Зупиняє виконання функції
    }

    widget.addTx(
      //розширення нашого віджету
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context)
        .pop(); //Після додавання нової транзакції вікно додавання закривається автоматчно
  }

  void _presentDatePicker() {
    //Опрацювання дат з якими ми можемо працювати під час додавання транзакції
    showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Ініціалізація дати
      firstDate: DateTime(2021), // дата до котрої ми можемо вернутись
      lastDate: DateTime.now(), // остання дата яку ми можемо вибрати (зараз)
    ).then((pickedDate) {
      // привласнюємо аргумент
      if (pickedDate == null) {
        return;
      }

      setState(() {
        //викликається для зміни стану віджету
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              // поле для заповнення текстом
              decoration: InputDecoration(labelText: 'Назва'),
              controller: _titleController, // збереження введеного
              onSubmitted: (_) =>
                  _submitData(), // для додавання даних через значок DONE на клавіатурі
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Вартість'),
              controller: _amountController, // збереження введеного
              keyboardType: TextInputType.number, // лише номерна клавіатура
              onSubmitted: (_) =>
                  _submitData(), // для додавання даних через значок DONE на клавіатурі
            ),
            Container( // Відображженя та вибір дати
              height: 70,
              child: Row(
                children: [
                  Text(DateFormat('d/M/y').format(_selectedDate)),
                  // ignore: deprecated_member_use
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Вибрати дату',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: _submitData,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Add transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
