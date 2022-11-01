import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_tracker/cubit/stock_data_cubit.dart';
import 'package:stock_tracker/repository/get_stock_data_repository.dart';
import 'package:stock_tracker/screen/stock_tracker_screen.dart';

void main() {
  return runApp(_app());
}

Widget _app() {
  return BlocProvider(
    create: (context) => StockDataCubit(repository: StockRepository()),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StockTrackerScreen(),
    ),
  );
}
