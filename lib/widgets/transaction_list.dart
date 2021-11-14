// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List transaction;
  final Function deleteTx;

  TransactionList(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty // Якщо список пустий то виводимо інший віджет
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
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
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/wait.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView(
            // Інакше виводмо наш список транзакцій
            children: transaction
                .map(
                  (tx) => TransactionItem(
                    // ств окремий файл цього віджету для легшого читання коду
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTx: deleteTx,
                  ),
                )
                .toList(),
          );
  }
}