import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController(); //контролер приймає в себе дані, які ми вводимо
  

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return; // Зупиняє виконання функції
    }

    widget.addTx( //розширення нашого віджету
      enteredTitle,
      enteredAmount,
    );

    Navigator.of(context).pop(); //Після додавання нової транзакції вікно додавання закривається автоматчно
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
              decoration: InputDecoration(labelText: 'Назва'),
              // onChanged: (val) => titleInput = val,
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Вартість'),
              // onChanged: (val) => amountInput = val,
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: submitData,
              textColor: Colors.purple,
              child: Text('Add transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
