import 'dart:async';
import 'package:http/http.dart' as http;
import 'stock.dart';
import 'dart:convert';

Future<Price> fetchStockPrice(String sticker) async {
  final response = await http.get(
      'https://api.iextrading.com/1.0/stock/$sticker/quote?displayPercent=true');

  final responseJson = json.decode(response.body);

  Price price = new Price();

  price.currentPrice = responseJson['latestPrice'];
  price.change = responseJson['change'];
  price.changePercent = responseJson['changePercent'];

  return price;
}

//https://api.iextrading.com/1.0/stock/jpm/company

Future<Stock> fetchStockCompany(String sticker) async {
  final response =
  await http.get('https://api.iextrading.com/1.0/stock/$sticker/company');
  final responseJson = json.decode(response.body);

  Stock stock = new Stock();

  stock.sticker = responseJson['symbol'];
  stock.companyName = responseJson['companyName'];

  print("inside fethstockcompany");

  print(stock.companyName);

  return stock;
}

init() {
  print("inside init");

  var list = <Stock>[];
/*
Stock stock1 = new Stock();
stock1.sticker="FB";
stock1.companyName="FACEBOOK";
list.add(stock1);

Stock stock2 = new Stock();
stock2.sticker="AMZN";
stock2.companyName="AMAZON";
list.add(stock2);

Stock stock3 = new Stock();
stock3.sticker="AAPL";
stock3.companyName="Apple";
list.add(stock3);

Stock stock4 = new Stock();
stock4.sticker="WFC";
stock4.companyName="WellsFargo";
list.add(stock4);
*/

  print(list.length);
  return list;
}
