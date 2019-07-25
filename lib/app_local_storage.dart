import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'data/sojson_weather.dart';

class AppLocalStorage {
  static const String _KEY_WEATHERS = "weathers";

  static Future<bool> setAutoLocationWeather(SojsonWeather weather) async {
    List<SojsonWeather> list = await getWeathers();
    if(list.isEmpty) {
      list.add(weather);
      return setWeathers(list);
    } else {
      for(SojsonWeather _weather in list) {
        if(_weather.isAutoLocation) {
          list.remove(_weather);
          break;
        }
      }
      return setWeathers([weather]..addAll(list));
    }
  }
  static Future<SojsonWeather> getAutoLocationWeather() async {
    List<SojsonWeather> list = await getWeathers();
    for(SojsonWeather _weather in list) {
      if(_weather.isAutoLocation) {
        return _weather;
      }
    }
    return null;
  }

  static Future<bool> setWeathers(List<SojsonWeather> weathers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_KEY_WEATHERS, jsonEncode(weathers));
  }
  static Future<List<SojsonWeather>> getWeathers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<SojsonWeather> weathers = List();
    if(prefs.containsKey(_KEY_WEATHERS)) {
      String json = prefs.getString(_KEY_WEATHERS);
      List<dynamic> listDynamic = jsonDecode(json);
      List<SojsonWeather> _weathers = listDynamic.map((weather) =>SojsonWeather.fromJson(weather)).toList();
      weathers.addAll(_weathers);
    }
    return weathers;
  }
}