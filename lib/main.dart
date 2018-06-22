import 'dart:async';
import 'addStock.dart';
import 'stock.dart';
import 'getStockData.dart';
import 'storeLocalData.dart';

import 'package:flutter/material.dart';

void main() => runApp(new StockList());

class StockList extends StatefulWidget {
  @override
  createState() => new StockListState(init());
}

class StockListState extends State<StockList> {
  var stocks = <Stock>[];

  StockListState(this.stocks);

  @override
  void initState() {
    super.initState();
    readStocks().then((List<Stock> stocks) {
      setState(() {
        this.stocks = stocks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("stock is initialized${stocks.length}");
    return new MaterialApp(
      title: 'Fetch Data Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: new Text('Watchlist'),
          ),
          actions: <Widget>[
            new Builder(builder: (BuildContext context) {
              return new IconButton(
                  icon: new Icon(Icons.add),
                  onPressed: () async {
                    Stock newStock = await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddStock()),
                    );
                    print("back");
                    print(newStock.sticker);

                    Future<Stock> successor =
                        fetchStockCompany(newStock.sticker);

                    successor.then((Stock newStockWithCompany) {
                      print("inside then");
                      if (newStockWithCompany.companyName == null) {
                        print("symbol is incorrect");

                        final snackBar = new SnackBar(
                          content: new Text(
                              'No matching symbol found for: ${newStock.sticker}'),
                          duration:
                              new Duration(hours: 0, minutes: 0, seconds: 5),
                          /*action: new SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change!
                              },
                            )*/
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      } else {
                        newStock = newStockWithCompany;
                        print(newStockWithCompany.companyName);

                        setState(() {
                          print("inside setState");
                          stocks.add(newStock);
                        });

                        writeStocks(stocks);
                      }
                    }, onError: (e) {
                      print("error while getting companyname");
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
        itemCount: stocks.length,
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

          if (index >= stocks.length) {
            if (stocks.length == 0 && index == 0) {
              return new Text("Watchlist is empty. Please add stocks.");
            }
            return;
          }
          print("index is $index and stock is ${stocks[index].sticker}");

          return getListTileForStock(stocks[index]);
        });
  }

  Widget getListTileForStock(Stock stock) {
    return new Dismissible(
        key: new Key(stock.sticker),
        onDismissed: (direction) {
          stocks.remove(stock);
          writeStocks(stocks);

          /* Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("$item dismissed")));*/
        },
        // Show a red background as the item is swiped away
        background: new Container(color: Colors.red),
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(stock.sticker + "\n" + stock.companyName),
              /*onLongPress: () {
        print("inside long press");
        print("${stock.sticker}");

        setState(() {
          print("inside setState");
          stocks.remove(stock);
        });
        print("saving after deletion");
        */ /*final snackBar = new SnackBar(
          content: new Text('Removing ${stock.sticker} from the list'),
          duration: new Duration(hours:0, minutes:0, seconds:5),
          */ /**/ /*action: new SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change!
                              },
                            )*/ /**/ /*
        );
        Scaffold.of(context).showSnackBar(snackBar);*/ /*
        writeStocks(stocks);
      },*/
              trailing: new Container(
                child: new FutureBuilder<Price>(
                  future: fetchStockPrice(stock.sticker),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.change < 0) {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "${snapshot.data.currentPrice.toStringAsFixed(2)}",
                              textAlign: TextAlign.right,
                            ),
                            new Text(
                              "${snapshot.data.change.toStringAsFixed(2)}",
                              textAlign: TextAlign.right,
                              style: new TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            new Text(
                              "${snapshot.data.changePercent.toStringAsFixed(2)}%",
                              textAlign: TextAlign.right,
                              style: new TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "${snapshot.data.currentPrice.toStringAsFixed(2)}",
                              textAlign: TextAlign.right,
                            ),
                            new Text(
                              "${snapshot.data.change.toStringAsFixed(2)}",
                              textAlign: TextAlign.right,
                              style: new TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            new Text(
                              "${snapshot.data.changePercent.toStringAsFixed(2)}%",
                              textAlign: TextAlign.right,
                              style: new TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      }
                    } else if (snapshot.hasError) {
                      return new Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return new CircularProgressIndicator();
                  },
                ),
              ),
            ),
            new Divider(),
          ],
        ));
  }
}
