import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'data/amap_location.dart';
import 'translations.dart';
import 'application.dart';
import 'strings.dart';
import 'utils/permission_util.dart';
import 'utils/snack_bar_util.dart';

class WeatherApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WeatherApp> {
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    myApplication.onLocaleChanged = onLocaleChange;
  }

  /// 改函数赋值给[MyApplication.onLocaleChanged], 在切换系统语言时，通过该方法实现app的国际化语言切换。
  /// 类似于Android中的点击事件的监听回调实现方式。
  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        _localeOverrideDelegate,
        const TranslationsDelegate(), //指向自定义个人库来处理翻译
        GlobalMaterialLocalizations
            .delegate, //为Material Components库提供本地化字符串和其他值
        GlobalWidgetsLocalizations.delegate, //为窗口小部件库定义从左到右或从右到左的默认文本方向
      ],
      //支持的语言列表
      supportedLocales: myApplication.supportedLocales(),

      title: 'Weather',
      onGenerateTitle: (context) {
        return Translations.of(context).getString(Strings.appName);
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  //声明一个调用对象，需要把kotlin中注册的ChannelName传入构造函数
  static const _location = const MethodChannel('app2m.com/location');
  @override
  void initState() {
    super.initState();
    _location.invokeMethod('stopLocation');
  }

  _requestLocation(BuildContext context) async {
    String prompt = Translations.of(context).getString(Strings.permissionPromptLocation);
    SnackBarAction action = AppSnackBarAction.getDefaultPermissionAction(context);
    PermissionGroup deniedPermission = await PermissionUtil.requestPermissions(context, [PermissionGroup.location], prompt, action: action);
    if(deniedPermission != PermissionGroup.location) {
      String result = await _location.invokeMethod('getLocation');
      Map locationMap = jsonDecode(result);
      var amapLocation = AmapLocation.fromJson(locationMap);
      print('jsonEncode(amapLocation) ====> ' + jsonEncode(amapLocation));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appbar title'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  _requestLocation(context);
                },
                child: Text('验证定位权限'),
              ),
              MaterialButton(
                onPressed: () {
                  String prompt = Translations.of(context).getString(Strings.permissionPromptLocation);
                  PermissionUtil.requestPermissions(context, [PermissionGroup.location], prompt, showPrompt: true);
                },
                child: Text('验证定位权限'),
              ),
            ],
          );
        },
      ),
    );
  }
}
