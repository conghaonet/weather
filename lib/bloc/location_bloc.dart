import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/network/api_service.dart';
import 'package:weather/utils/location_util.dart';
import 'package:connectivity/connectivity.dart';
import 'package:weather/utils/util.dart';

import '../app_local_storage.dart';
import '../data/province_city.dart';
import '../data/amap_location.dart';
import '../app_channels.dart';
import '../exceptions.dart';
import 'bloc_provider.dart';

class LocationBloc extends BlocBase {
  Logger _log = Logger('LocationBloc');
  AmapChannel _amapChannel = AmapChannel();
  final _controller = StreamController<SojsonWeather>.broadcast();
  Stream<SojsonWeather> get locationStream => _controller.stream;
  final _errController = StreamController<Exception>.broadcast();
  Stream<Exception> get errorStream => _errController.stream;
  void myLocationWeather() async {
    if((await Util.networkIsConnective()) == null) {
      return _controller.sink.addError(MyNetworkException("无网络链接，定位失败！"));
    }
    _amapChannel.getLocation().then<City>((location){
      return LocationUtil.getCityByLocation(location);
    }, onError: (e, stack) {
      var exception = MyNetworkException("无网络链接，定位失败！");
      _controller.sink.addError(exception);
      throw exception;
    }).then<SojsonWeather>((city) {
      if(city != null) {
        return ApiService.getSojsonWeather(city.cityCode);
      } else {
        var exception = MyCityConvertException("网络错误，无匹配的城市编码。");
        _controller.sink.addError(exception);
        throw exception;
      }
    }).then((weather) {
      if(weather != null) {
        weather.isAutoLocation = true;
        _log.info(weather);
        AppLocalStorage.setAutoLocationWeather(weather);
        _controller.sink.add(weather);
      }
    }).catchError((e, stack) {
      _controller.sink.addError(e, stack);
      _log.severe("exception is MyBaseException: ${(e as MyBaseException).message}");
    }, test: (e) {
      return e is MyBaseException;
    }).catchError((e, stack) {
      _controller.sink.addError(e, stack);
      _log.severe("exception is PlatformException: ${(e as PlatformException).message}");
    }, test: (e) {
      return e is PlatformException;
    }).catchError((e, stack) {
      _controller.sink.addError(e, stack);
      _log.severe("exception is Exception: ${(e as Exception).toString()}");
    }, test: (e) => e is Exception);
  }

  @deprecated
  void autoLocationWeather() {
    AppLocalStorage.getAutoLocationWeather().then((weather) {
      if(weather != null) {
        _log.fine(weather);
        _controller.sink.add(weather);
      }
    }).then<AmapLocation>((_) async {
      if(await Util.networkIsConnective() != null) {
        return _amapChannel.getLocation();
      } else {
        throw MyNetworkException("无网络链接，定位失败！");
      }
    }).then<City>((amapLocation) {
      return LocationUtil.getCityByLocation(amapLocation);
    }).then<SojsonWeather>((city) async {
      ConnectivityResult result = await Connectivity().checkConnectivity();
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        return city != null ? ApiService.getSojsonWeather(city.cityCode): throw MyCityConvertException("网络错误，无匹配的城市编码。");
      } else {
        throw MyNetworkException("无链接，请检查您的网络设置！");
      }
    }).then((weather) {
      if(weather != null) {
        weather.isAutoLocation = true;
        _log.info(weather);
        AppLocalStorage.setAutoLocationWeather(weather);
        _controller.sink.add(weather);
      }
    }).catchError((e){
      _errController.sink.addError(e);
    }, test: (e) => e is PlatformException || e is MyBaseException).catchError((e){
      _errController.sink.addError(e);
    });
  }

  void stopLocation() {
    _amapChannel.stopLocation();
  }
  @override
  void dispose() {
    _amapChannel = null;
    stopLocation();
    _controller.close();
    _errController.close();
  }

}