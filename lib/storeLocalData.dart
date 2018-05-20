import 'dart:async';
import 'dart:io';
import 'stock.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/stocks.txt');
}

Future<List<Stock>> readStocks() async {
  try {
    print("inside readstocks");
    final file = await _localFile;
    var stocks = <Stock>[];
    // Read the file
    List<String> contents = await file.readAsLines();
    print("contents:${contents.length}");
    for (var i = 0; i < contents.length; i++) {
      String str = contents[i];
      var strArr = str.split(",");
      Stock newStock = new Stock();
      newStock.sticker = strArr[0];
      newStock.companyName = strArr[1];
      print("adding stock${newStock.sticker}");
      stocks.add(newStock);
    }
    return stocks;
  } catch (e) {
    // If we encounter an error, return 0
    return <Stock>[];
  }
}

writeStocks(List<Stock> stocks) async {
  print("inside writestocks");
  final file = await _localFile;

  StringBuffer sb = new StringBuffer();

  for (var i = 0; i < stocks.length; i++) {
    sb.writeln(stocks[i].sticker + "," + stocks[i].companyName);
    //file.writeAsString(stocks[i].sticker+","+stocks[i].companyName+"\n");
    print("writing: " + stocks[i].sticker + "," + stocks[i].companyName);
  }

  print("going into file:" + sb.toString());
  file.writeAsString(sb.toString());

  print("returning from writestocks");
}
