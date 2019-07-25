import 'dart:async';

import 'package:logging/logging.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/network/api_service.dart';

import '../app_local_storage.dart';
import 'bloc_provider.dart';
import 'package:dio/dio.dart';

class CitiesWeatherBloc extends BlocBase {
  Logger _log = Logger('CitiesWeather');
  final _controller = StreamController<List<SojsonWeather>>.broadcast();
  Stream<List<SojsonWeather>> get citiesStream => _controller.stream;
  final List<SojsonWeather> _allWeathers = List();

  void allCitesWeather() async {
    _allWeathers.clear();
    _allWeathers.addAll(await AppLocalStorage.getWeathers());
    _controller.sink.add(_allWeathers);
    for(SojsonWeather _weather in _allWeathers) {
      try {
        SojsonWeather newWeather = await ApiService.getSojsonWeather(_weather.cityInfo.citykey);
        if(_weather.isAutoLocation) {
          newWeather.isAutoLocation = true;
        }
        _weather = newWeather;
      } on DioError catch(e, stack) {
        _controller.sink.addError(e, stack);
        _log.severe("getSojsonWeather is DioError", e, stack);
      } on Exception catch(e, stack) {
        _controller.sink.addError(e, stack);
        _log.severe("getSojsonWeather is Exception", e, stack);
      }
    }
    AppLocalStorage.setWeathers(_allWeathers);
    _controller.sink.add(_allWeathers);
  }

  void addCity(String citykey) async {
    for(SojsonWeather weather in _allWeathers) {
      if(weather.cityInfo.citykey == citykey) {
        _controller.sink.addError("城市已存在");
        return;
      }
    }
    try {
      SojsonWeather newWeather = await ApiService.getSojsonWeather(citykey);
      if(newWeather != null) {
        _allWeathers.add(newWeather);
        AppLocalStorage.setWeathers(_allWeathers);
        _controller.sink.add(_allWeathers);
      } else {
        _controller.sink.addError("城市添加失败，未知错误！");
      }
    } on Exception catch(e, stack) {
      _controller.sink.addError(e.toString());
      _log.severe("getSojsonWeather is error", e, stack);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }

}