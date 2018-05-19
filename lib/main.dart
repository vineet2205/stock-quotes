
import 'dart:async';
import 'addStock.dart';
import 'stock.dart';
import 'getStockData.dart';

import 'package:flutter/material.dart';



void main() => runApp(new StockList());

class StockList extends StatefulWidget {

  @override
  createState() => new StockListState(init());
  
}

class StockListState extends State<StockList> {
  var stock = <Stock>[];

  StockListState(this.stock);

  @override
  Widget build(BuildContext context) {

    print("stock is initialized${stock.length}");
    return new MaterialApp(
      title: 'Fetch Data Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Stock Prices'),
          actions: <Widget>[
            new Builder(builder: (BuildContext context) {
              return new IconButton(
                  icon: new Icon(Icons.add),
                  onPressed: () async {
                  Stock newStock =  await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddStock()),
                    );
                  print("back");
                  print(newStock.sticker);

                  Future<Stock> successor = fetchStockCompany(newStock.sticker);

                  successor.then((Stock newStockWithCompany) {

                    newStock=newStockWithCompany;
                    print("inside then");
                    print(newStockWithCompany.companyName);

                    setState(() {
                      print("inside setState");
                      stock.add(newStock);
                    });
                  },
                      onError: (e) {
                        throw e;
                      });


                  });
            })
          ],
        ),
        body: _buildStockList(),
      ),
    );
  }


  Widget _buildStockList() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {


          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return new Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          /*if (index >= stock.length) {
  // ...then generate 10 more and add them to the suggestions list.
  stock.addAll(generateWordPairs().take(10));
  }*/

          if(index>=stock.length){
            return;
          }
          print ("index is $index and stock is ${stock[index].sticker}");

          return getListTileForStock(stock[index]);
        }
    );
  }

  Widget getListTileForStock(Stock stock) {
    return new ListTile(
      title: new Text(stock.companyName + " : " + stock.sticker),
      trailing: new Container(
        child: new FutureBuilder<String>(
          future: fetchStockPrice(stock.sticker),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Text(snapshot.data);
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return new CircularProgressIndicator();
          },
        ),
      ),
    );
  }

}

