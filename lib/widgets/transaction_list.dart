import "package:flutter/material.dart";
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List transaction;
  final Function deleteTx;

  TransactionList(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 515,
      child: transaction.isEmpty // Якщо список пустий то виводимо інший віджет
          ? Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Жодної транзакції, додайте їх',
                  style: TextStyle(
                      fontSize: 20,
                      backgroundColor: Colors.amber,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 150,
                    child: Image.asset('assets/images/wait.png',
                        fit: BoxFit.cover)),
              ],
            )
          : ListView.builder(
              // Інакше виводмо наш список транзакцій
              itemBuilder: (ctx, index) {
                //ctx певний ств віджет, індекс це його номирація
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                              '₴${transaction[index].amount}'), //передаємо вартість
                        ),
                      ),
                    ),
                    title: Text(
                      transaction[index].title, //назва транзакції
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .format(transaction[index].date), //дата транзакції
                    ),
                    trailing: IconButton(
                      //видалення транзакції
                      onPressed: () => deleteTx(transaction[index].id), //необхідно передати аргумент (наш ІД транзакції)
                      icon: Icon(Icons.delete_outlined),
                      color: Theme.of(context).errorColor,
                    ), //останній елемент (видалення\корегування тощо)
                  ),
                );
              },
              itemCount:
                  transaction.length, //покращує опрацювання для прокрутки
            ),
    );
  }
}
