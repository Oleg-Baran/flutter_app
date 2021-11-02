import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function _handler;

  AdaptiveFlatButton(this.text, this._handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              'Вибрати дату',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => _handler())
        // ignore: deprecated_member_use
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: () => _handler(),
            child: Text(
              'Вибрати дату',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
