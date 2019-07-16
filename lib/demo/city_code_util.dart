import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../data/province_city.dart';

void main() => runApp(CityCodeApp());

class CityCodeApp extends StatefulWidget {
  @override
  CityCodeAppState createState() => CityCodeAppState();
}

class CityCodeAppState extends State<CityCodeApp> {
  void loadAsset() async {
    String strFile = await rootBundle.loadString('assets/city_code.txt');
    List<Province> provinces = List();
    List<String> list = strFile.split("\r\n\r\n\r\n");
    list.forEach((item) {
      if(item.trim() != "") {
        List<City> cities = List();
        List<String> subList = item.split("\r\n");
        if(subList.isNotEmpty) {
          subList.forEach((subItem) {
            List<String> codeAndName = subItem.split("=");
            if(codeAndName.isNotEmpty) {
              City city = City(codeAndName[0], codeAndName[1]);
              cities.add(city);
            }
          });
        }
        if(cities.isNotEmpty) {
          Province province = Province(cities[0].cityCode, cities[0].cityName, cities);
          provinces.add(province);
        }
      }
    });
    print(provinces.toString());
  }
  @override
  void initState() {
    super.initState();
    loadAsset();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityCodeApp',
      home: Scaffold(
        appBar: null,
        body: Center(
          child: Text('aaaaaaaaaa'),
        ),
      ),
    );
  }

}
