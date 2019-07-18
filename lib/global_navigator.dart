import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:weather/page/home.dart';
import 'page/location_city_page.dart';
import 'page/settings_page.dart';

class GlobalNavigator extends NavigatorObserver {
  /// 保存单例
  static final GlobalNavigator _globalNavigator = GlobalNavigator._internal();
  /// 静态路由（无参数）
  static final Map<String, WidgetBuilder> _routes = {
    SettingsPage.ROUTE_NAME: (_) => SettingsPage(),
    LocationCityPage.ROUTE_NAME: (_) => LocationCityPage(),
  };
  Map<String, WidgetBuilder> get routes => _routes;

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

  /// 带参数路由
  Route<dynamic> generateRoute(RouteSettings settings) {
    MaterialPageRoute defaultPage = MaterialPageRoute(builder: (context) {return HomePage();});
    MaterialPageRoute targetPage;
/*
    if(settings.name == SettingsPage.ROUTE_NAME) {
      targetPage = MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return SettingsPage();
        },
      );
    }
*/
    return targetPage ?? defaultPage;
  }

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