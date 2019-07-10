import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

import 'app_home.dart';

void main() {
  //格式化堆栈信息
  Chain.capture(() {
    runApp(WeatherApp());
  });
}
