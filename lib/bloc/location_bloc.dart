import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/network/api_service.dart';
import 'package:weather/utils/location_util.dart';
import 'package:weather/utils/util.dart';

import '../app_local_storage.dart';
import '../data/province_city.dart';
import '../app_channels.dart';
import '../exceptions.dart';
import 'bloc_provider.dart';

class LocationBloc extends BlocBase {
  Logger _log = Logger('LocationBloc');
  AmapChannel _amapChannel = AmapChannel();
  final _controller = StreamController<SojsonWeather>.broadcast();
  Stream<SojsonWeather> get locationStream => _controller.stream;
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

  void stopLocation() {
    _amapChannel.stopLocation();
  }
  @override
  void dispose() {
    stopLocation();
    _controller.close();
  }

}