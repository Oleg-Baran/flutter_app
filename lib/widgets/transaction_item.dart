import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tansaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;

  @override
  void initState() { //Запускається перед ств стану і тут ми отримуємо наші кольори для Аватарок
    const avaliableColors = [
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.amber,
    ];

    _bgColor = avaliableColors[Random().nextInt(5)]; //Рандомний колір для Аватарок
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor, //передаємо наші кольори
          foregroundColor: Colors.white,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('₴${widget.transaction.amount}'), //передаємо вартість
            ),
          ),
        ),
        title: Text(
          widget.transaction.title, //назва транзакції
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date), //дата транзакції
        ),
        trailing: MediaQuery.of(context).size.width > 460
            // ignore: deprecated_member_use
            ? FlatButton.icon(
                icon: const Icon(Icons.delete_outlined),
                label: const Text('Delete'),
                textColor: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                //видалення транзакції
                onPressed: () => widget.deleteTx(widget.transaction
                    .id), //необхідно передати аргумент (наш ІД транзакції)
                icon: const Icon(Icons.delete_outlined),
                color: Theme.of(context).errorColor,
              ), //останній елемент (видалення\корегування тощо)
      ),
    );
  }
}
