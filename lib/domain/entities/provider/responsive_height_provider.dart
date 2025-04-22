
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ResponsiveHeightProvider{
  final logger = Logger();
  double? _resHeight;
  double? get resHeight => _resHeight;

  void setHeight (BuildContext context){
    double screenHeight = MediaQuery.sizeOf(context).height;
    double statusBarHeight = MediaQuery.paddingOf(context).top;
    double bottomBarHeight = MediaQuery.paddingOf(context).bottom;
    double appBarHeight = kToolbarHeight;
    // logger.d("screenHeight : $screenHeight / statusBarHeight : $statusBarHeight / bottomBarHeight : $bottomBarHeight / appBarHeight : $appBarHeight");

    _resHeight = screenHeight - statusBarHeight - bottomBarHeight - appBarHeight;
    _resHeight = _resHeight!.floorToDouble();
  }
}