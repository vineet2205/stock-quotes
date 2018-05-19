import 'dart:async';
import 'dart:convert';
import 'stock.dart';
import 'getStockData.dart';

import 'package:flutter/material.dart';
class AddStock extends StatelessWidget {

  final myController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Stocks"),
      ),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new TextField(controller: myController,
            ),

          ),
          new RaisedButton(onPressed: () {
            print("going back");
            print(myController.text);
            Stock stock=new Stock();
            stock.sticker=myController.text;
            stock.companyName=" ";
            /*Future<Stock> successor = fetchStockCompany(myController.text);

            successor.then((Stock newStock) {

              stock=newStock;
              print("inside then");
              print(stock.companyName);


            },
                onError: (e) {
                 throw e;
                });*/


print("returning.................");
            Navigator.pop(context,stock);
          },
              child: new Text("add")),

        ],
      ),

      floatingActionButton: new FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // text the user has typed into our text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                // Retrieve the text the user has typed in using our
                // TextEditingController
                content: new Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: new Icon(Icons.add),
      ),

    );

  }
}