import 'package:cctracker/CCList.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CCTracker());

class CCTracker extends StatelessWidget {
  const CCTracker({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome CC Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      home: CCList(),
    );
    throw UnimplementedError();
  }
}