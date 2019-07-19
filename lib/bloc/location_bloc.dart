import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/network/api_service.dart';
import 'package:weather/utils/location_util.dart';

import '../app_local_storage.dart';
import '../data/province_city.dart';
import '../data/amap_location.dart';
import '../app_channels.dart';
import 'bloc_provider.dart';

class LocationBloc extends BlocBase {
  final _controller = StreamController<SojsonWeather>.broadcast();
  Stream<SojsonWeather> get locationStream => _controller.stream;
  AmapChannel _amapChannel = AmapChannel();

  void autoLocationWeather() async {
    AppLocalStorage.getAutoLocationWeather().then((weather) {
      if(weather != null) {
        _controller.sink.add(weather);
      }
    }).then<AmapLocation>((_){
      return _amapChannel.getLocation();
    }, onError: (e){
      print(e.toString());
      _controller.sink.addError(e);
      throw e;
    }).then<City>((amapLocation) {
      return LocationUtil.getCityByLocation(amapLocation);
    }).then<SojsonWeather>((city) {
      return city != null ? ApiService.getSojsonWeather("aaa"+city.cityCode): null;
    }, onError: (e){
      throw e;
    }).then((weather) {
      if(weather != null) {
        AppLocalStorage.setAutoLocationWeather(weather);
        _controller.sink.add(weather);
      }
    }, onError: (e) {
      _controller.sink.addError("getSojsonWeather onError >>>>>>"+e.toString());
    }).catchError((e) {
      _controller.sink.addError("TimeoutException>>>>>>"+e.toString());
    }, test: (e) => e is TimeoutException).catchError((e) {
      _controller.sink.addError("PlatformException>>>>>>"+e.toString());
    }, test: (e) => e is PlatformException).catchError((e) {
      _controller.sink.addError("DefaultException>>>>>>"+e.toString());
    });

  }

/*
  void locationCity() async {
    _amapChannel.getLocation().then<AmapLocation>((amapLocation) {
      return amapLocation;
    }, onError: (e) {
      throw Future(e);
    }).then<City>((amapLocation) async {
      City city = await LocationUtil.getCityByLocation(amapLocation);
      _controller.sink.add(city);
      return city;
    }).then<bool>((city) async {
      List<SojsonWeather> weathers = await AppLocalStorage.getWeathers();
      print("weathers 1 ====> ${weathers.toString()}");
      SojsonWeather weatherA = await ApiService.getSojsonWeather('101010100');
      print('getSojsonWeather ====> ${weatherA.toString()}');
      return AppLocalStorage.setWeathers([weatherA]);
    }, onError: (e) {
      print("getSojsonWeather onError ====> ${e.toString()}");
    }).then((result) async {
      if(result) {
        List<SojsonWeather> weathers = await AppLocalStorage.getWeathers();
        print("weathers 2 ====> ${weathers.toString()}");
        SojsonWeather autoLocationWeather = await AppLocalStorage.getAutoLocationWeather();
        print("autoLocationWeather ====> ${autoLocationWeather.toString()}");
      }
    });

  }
*/
  void stopLocation() {
    _amapChannel.stopLocation();
  }
  @override
  void dispose() {
    _amapChannel = null;
    _controller.close();
  }

}