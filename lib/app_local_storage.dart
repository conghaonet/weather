import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'data/sojson_weather.dart';

class AppLocalStorage {
  static const String _KEY_WEATHERS = "weathers";
  static const String _KEY_AUTO_LOCATION_WEATHER = "auto_location_weather";

  static Future<bool> setAutoLocationWeather(SojsonWeather weather) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_KEY_AUTO_LOCATION_WEATHER, jsonEncode(weather));
  }
  static Future<SojsonWeather> getAutoLocationWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(_KEY_AUTO_LOCATION_WEATHER)) {
      String json = prefs.getString(_KEY_AUTO_LOCATION_WEATHER);
      Map<String, dynamic> map = jsonDecode(json);
      SojsonWeather weather = SojsonWeather.fromJson(map);
      return weather;
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