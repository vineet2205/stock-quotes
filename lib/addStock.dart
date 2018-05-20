import 'dart:async';
import 'dart:convert';
import 'stock.dart';
import 'getStockData.dart';

import 'package:flutter/material.dart';

class AddStock extends StatelessWidget {
  final myController = new TextEditingController();

  addSymbol(BuildContext context) {
    print("going back");
    print(myController.text);
    Stock stock = new Stock();
    stock.sticker = myController.text;
    stock.companyName = " ";

    print("returning.................");
    Navigator.pop(context, stock);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Stocks"),
      ),
      body: Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new TextField(
              controller: myController,
              decoration: InputDecoration(
                helperText: "Enter a stock symbol to add to the Watchlist",
              ),
              onSubmitted: (String) {
                addSymbol(context);
              },
            ),
          ),
          new RaisedButton(
              onPressed: () {
                addSymbol(context);
              },
              child: new Text("add")),
        ],
      ),
    );
  }
}
