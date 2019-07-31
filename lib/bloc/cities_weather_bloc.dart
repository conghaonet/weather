import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:logging/logging.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/network/api_service.dart';
import 'package:weather/utils/util.dart';

import '../app_local_storage.dart';
import '../exceptions.dart';
import 'bloc_provider.dart';
import 'package:dio/dio.dart';

class CitiesWeatherBloc extends BlocBase {
  Logger _log = Logger('CitiesWeatherBloc');
  final List<SojsonWeather> _allWeathers = List();
  final _controller = StreamController<List<SojsonWeather>>.broadcast();
  Stream<List<SojsonWeather>> get citiesStream => _controller.stream;
  final _errorController = StreamController<Exception>.broadcast();
  Stream<Exception> get errorStream => _errorController.stream;

  void allCitesWeather({bool isReload=false}) async {
    _allWeathers.clear();
    _allWeathers.addAll(await AppLocalStorage.getWeathers());
    _controller.sink.add(_allWeathers);
    if(isReload) {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        try {
          for(SojsonWeather _weather in _allWeathers) {
            try {
              SojsonWeather newWeather = await ApiService.getSojsonWeather(_weather.cityInfo.citykey);
//            Response<Map<String, dynamic>> response = await dioClient.dio.get("/city/${_weather.cityInfo.citykey}");
//            SojsonWeather newWeather = SojsonWeather.fromJson(response.data);

              if(_weather.isAutoLocation != null && _weather.isAutoLocation) {
                newWeather.isAutoLocation = true;
              }
              _weather = newWeather;
            } on DioError catch(e, stack) {
              _log.severe("allCitesWeather DioError", e, stack);
            }
          }
        } catch(e, stack) {
          _errorController.sink.addError(e);
          _log.severe("allCitesWeather Exception", e, stack);
        }
      } else {
        _errorController.sink.addError(MyNetworkException('无网络链接，数据更新失败！'));
      }
      AppLocalStorage.setWeathers(_allWeathers);
      _controller.sink.add(_allWeathers);
    }
  }

  void addCity(String citykey) async {
    for(SojsonWeather weather in _allWeathers) {
      if(weather.cityInfo.citykey == citykey) {
        _errorController.sink.addError(MyBaseException('"城市已存在"'));
        return;
      }
    }
    try {
      if(Util.networkIsConnective() != null) {
        SojsonWeather newWeather = await ApiService.getSojsonWeather(citykey);
        if(newWeather != null) {
          _allWeathers.add(newWeather);
          AppLocalStorage.setWeathers(_allWeathers);
          _controller.sink.add(_allWeathers);
        } else {
          _errorController.sink.addError(MyBaseException('城市添加失败，未知错误！'));
        }
      } else {
        _errorController.sink.addError(MyNetworkException('无网络链接，城市添加失败！'));
      }
    } on Exception catch(e, stack) {
      _errorController.sink.addError(e);
      _log.severe("addCity Exception", e, stack);
    }
  }

  void delCity(String citykey) async {
    for(SojsonWeather _weather in _allWeathers) {
      if(_weather.cityInfo.citykey == citykey) {
        _allWeathers.remove(_weather);
        bool isSuccessful = await AppLocalStorage.setWeathers(_allWeathers);
        if(isSuccessful) _controller.sink.add(_allWeathers);
        else _errorController.sink.addError(MyBaseException('无网络链接，城市添加失败！'));
        return;
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
    _errorController.close();
  }

}