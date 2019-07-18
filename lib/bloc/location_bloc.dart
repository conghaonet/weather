import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/network/api_service.dart';
import 'package:weather/utils/location_util.dart';

import '../data/province_city.dart';
import '../data/amap_location.dart';
import '../app_channels.dart';
import 'bloc_provider.dart';

class LocationBloc extends BlocBase {
  final _controller = StreamController<City>.broadcast();
  Stream<City> get locationStream => _controller.stream;
  AmapChannel _amapChannel = AmapChannel();

  void locationCity() async {
    String strLocation = await _amapChannel.getLocation();
    Map<String, dynamic> locationMap = jsonDecode(strLocation);
    AmapLocation amapLocation = AmapLocation.fromJson(locationMap);
    City city = await LocationUtil.getCityByLocation(amapLocation);
    _controller.sink.add(city);

    SojsonWeather weatherA = await ApiService.getCityWeatherA('101010100');
    print('weatherA ====> ${weatherA.toString()}');

  }
  void stopLocation() {
    _amapChannel.stopLocation();
  }
  @override
  void dispose() {
    _amapChannel = null;
    _controller.close();
  }

}