import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'page/settings_page.dart';

class GlobalNavigator extends NavigatorObserver {
  /// 保存单例
  static final GlobalNavigator _globalNavigator = GlobalNavigator._internal();
  static final Map<String, WidgetBuilder> _routes = {
    SettingsPage.ROUTE_NAME: (_) => SettingsPage(),
  };
  factory GlobalNavigator() {
    return _globalNavigator;
  }

  GlobalNavigator._internal();

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if(route.settings != null && route.settings.name != null){
      setPreferredOrientations(route.settings.name);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if(previousRoute.settings != null && previousRoute.settings.name != null){
      setPreferredOrientations(previousRoute.settings.name);
    }
  }

  Map<String, WidgetBuilder> get routes => _routes;

  void setPreferredOrientations(String targetName) {
/*
    if(targetName == "/") {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // 恢复系统默认UI：显示状态栏、虚拟按键导航栏
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else if(CategoryPage.routeName == targetName) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // 隐藏状态栏、虚拟按键导航栏
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else if(DetailPage.routeName == targetName) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // 隐藏状态栏、虚拟按键导航栏
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
*/
  }
}

GlobalNavigator globalNavigator = GlobalNavigator();