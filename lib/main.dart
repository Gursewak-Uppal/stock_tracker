import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_tracker/cubit/stock_data_cubit.dart';
import 'package:stock_tracker/repository/get_stock_data_repository.dart';
import 'package:stock_tracker/screen/stock_tracker_screen.dart';
import 'package:stock_tracker/utils/app_utlis.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    statusBarColor: AppUtils.appColor, // status bar color
  ));
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
