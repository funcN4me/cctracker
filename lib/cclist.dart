import 'dart:convert' as convert;

import 'package:cctracker/ccdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CCList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CCListState();
  }
  
}

class CCListState extends State<CCList> {
  List<CCData> data = [];
  String apiKey = 'e1c3520f61-19fb8b3612-r1y8ma';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Awesome CC Tracker'),
        ),
        body: ListView(
          children: _buildList(),
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh_rounded),
        onPressed: () => _loadCC(),
      ),
    );
  }

  _loadCC() async{
    final fetchAll = await http.get(Uri.parse('https://api.fastforex.io/fetch-all?api_key=$apiKey'));
    final currency = await http.get(Uri.parse('https://api.fastforex.io/currencies?api_key=$apiKey'));

    var ccDataList = <CCData>[];

    Map<String, dynamic> test = {};
    Map<String, dynamic> currencyMap = {};
    List<String> currencyNameList = [];
    List<String> currencySymbolList = [];
    List<String> currencyPriceList = [];

    if (currency.statusCode == 200) {
      currencyMap = (convert.jsonDecode(currency.body) as Map)['currencies'] as Map<String, dynamic>;
    }

    for (var entry in currencyMap.entries) {
      currencyNameList.add(entry.value);
    }

    if (fetchAll.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(fetchAll.body) as Map<String, dynamic>;
      test = jsonResponse['results'];
    }

    for (var entry in test.entries) {
      currencySymbolList.add(entry.key);
      currencyPriceList.add(entry.value.toString());
    }

    for (var i = 0; i < currencyNameList.length; i++) {
      var record = CCData(id: i + 1,name: currencyNameList[i], symbol: currencySymbolList[i], price: currencyPriceList[i]);
      ccDataList.add(record);
    }

    setState(() {
      data = ccDataList;
    });

  }

  List<Widget> _buildList() {
    return data.map((CCData f) => ListTile(
      title: Text(f.name.toString()),
      subtitle: Text(f.symbol.toString()),
      leading: CircleAvatar(child: Text(f.symbol.toString(), style: const TextStyle(fontSize: 15),
      )),
      trailing: Text('\$${f.price.toString()}'),
    )).toList();
  }

}