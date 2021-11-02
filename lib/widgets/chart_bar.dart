import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPct;

  ChartBar(this.label, this.spendingAmount, this.spendingPct);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( //Об'єкт який приймає параметр контесту та обмеження, має інформацію про висоту та ширину об'єкта, який повертає.
      builder: (ctx, constraints) {
        return Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                    '₴${spendingAmount.toStringAsFixed(0)}'), //Price in the chart
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                //діаграма
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(
                          20), // сірі колбочки(шкала витрат)
                    ),
                  ),
                  FractionallySizedBox(
                    //Віджет який накладається на наш контейнер, в якому відображається шкала витрат
                    heightFactor: spendingPct, //Для заповнення шкали втрат
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                            20), //Звповнення нашої шкали відносно витрат
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(height: constraints.maxHeight * 0.15, child: Text(label),),
          ],
        );
      },
    );
  }
}
