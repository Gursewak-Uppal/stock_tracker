import 'package:flutter/material.dart';
import 'package:stock_tracker/screen/stock_tracker_screen.dart';

void main(){
  return runApp(_app());
}

Widget _app() {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StockTrackerScreen(),
  );
}