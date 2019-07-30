import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'application.dart';
import 'bloc/application_bloc.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/cities_weather_bloc.dart';
import 'bloc/location_bloc.dart';
import 'global_navigator.dart';
import 'package:weather/page/home.dart';
import 'strings.dart';
import 'translations.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    String strErr = '';
    if(rec.error != null) {
      strErr = '\n- ERROR: ${rec.error}';
    }
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: - MESSAGE: ${rec.message} $strErr \n${rec.stackTrace ?? ''}');
  });
  //格式化堆栈信息
  Chain.capture(() {
    runApp(MyApp());
  });
  if(Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green[500], //状态栏背景色
        statusBarIconBrightness: Brightness.light, //状态栏图标：黑色
        systemNavigationBarColor: Colors.green[800], //系统导航栏（虚拟按键）背景色
        systemNavigationBarIconBrightness: Brightness.light, //系统导航栏按键（虚拟按键）：黑色
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [ApplicationBloc(), LocationBloc(), CitiesWeatherBloc(),],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyMaterialAppState();
  }
}

class MyMaterialAppState extends State<MyMaterialApp> {
  ApplicationBloc _applicationBloc;
  @override
  void initState() {
    super.initState();
    _applicationBloc = BlocProvider.first<ApplicationBloc>(context);
    _applicationBloc.applicationStream.listen((event) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 定义静态路由，不能传递参数
      routes: globalNavigator.routes,
      //动态路由，可传递参数
      onGenerateRoute: globalNavigator.generateRoute,
      localizationsDelegates: [
        _applicationBloc.localeOverrideDelegate,
        const TranslationsDelegate(), //指向自定义个人库来处理翻译
        GlobalMaterialLocalizations.delegate, //为Material Components库提供本地化字符串和其他值
        GlobalWidgetsLocalizations.delegate, //为窗口小部件库定义从左到右或从右到左的默认文本方向
      ],
      //支持的语言列表
      supportedLocales: myApplication.supportedLocales(),
      theme: ThemeData(
        accentColor: Colors.green[500],
        brightness: Brightness.light,
        primaryColor: Colors.green[500],
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white,),

        ),
      ),
      title: 'WEATHER',
      onGenerateTitle: (context) {
        return Translations.of(context).getString(Strings.app_name);
      },
      home: HomePage(),
    );
  }
}