import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/amap_location.dart';
import '../data/province_city.dart';

class LocationUtil {
  static Future<City> getCityByLocation(AmapLocation location) async {
    String json = await rootBundle.loadString('assets/cities.json');
    List<dynamic> list = jsonDecode(json);
    List<Province> provinces = list.map((province) =>Province.fromJson(province)).toList();
    for(Province province in provinces) {
      for(City city in province.cities) {
        if(city.cityName == location.city || '${city.cityName}市' == location.city) {
          return city;
        }
      }
    }
    return null;
  }
}