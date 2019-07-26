import 'dart:convert';

import 'package:flutter/material.dart';
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

  static Future<List<Province>> getProvincesData(BuildContext context) async {
    AssetBundle bundle = DefaultAssetBundle.of(context);
    String json = await bundle.loadString('assets/cities.json');
    List<dynamic> listDynamic = jsonDecode(json);
    List<Province> provinces = listDynamic.map((js) =>Province.fromJson(js)).toList();
    // print("getProvincesData ====> "+provinces.toString());
    return provinces;
  }
}