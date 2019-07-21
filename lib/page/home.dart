import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'package:weather/bloc/application_bloc.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/data/amap_location.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/page/settings_page.dart';
import 'package:weather/translations.dart';
import 'package:weather/application.dart';
import 'package:weather/strings.dart';
import 'package:weather/utils/permission_util.dart';
import 'package:weather/utils/snack_bar_util.dart';
import 'package:weather/utils/util.dart';
import 'package:weather/bloc/cities_page_bloc.dart';
import 'package:weather/data/province_city.dart';

import 'location_city_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocationBloc _locationBloc = BlocProvider.first<LocationBloc>(context);
    _locationBloc.autoLocationWeather();
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<SojsonWeather>(
          stream: _locationBloc.locationStream,
          builder: (BuildContext context, AsyncSnapshot<SojsonWeather> snapshot) {
            if(snapshot.hasData) {
              return Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () {
                      Util.showToast("location");
                    },
                  ),
                  Text(snapshot.data.cityInfo.city,),
                ],
              );
            } else {
              return Text(Translations.of(context).getString(Strings.app_name),);
            }
          },
        ),
        actions: _getAppBarActions(context),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _liveWeatherCard(_locationBloc),
            StreamBuilder<SojsonWeather>(
              stream: _locationBloc.locationStream,
              builder: (BuildContext context, AsyncSnapshot<SojsonWeather> snapshot) {
                if(snapshot.hasData) {
                  return Text('当前城市：${snapshot.data.cityInfo.city}');
                } else if(snapshot.hasError) {
                  return Text('Error: ${snapshot.error.toString()}');
                } else {
                  return Text('未定位到所在城市');
                }
              },
            ),
            /*
            MaterialButton(
              child: Text(Translations.of(context).getString(Strings.location)),
              onPressed: () {
                BlocProvider.first<ApplicationBloc>(context).onChangeLocale(Locale('zh'));
              },
            ),
*/
          ],
        ),
      ),
    );
  }
  List<Widget> _getAppBarActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.location_city),
        onPressed: () {
          Navigator.pushNamed(context, LocationCityPage.ROUTE_NAME);
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, SettingsPage.ROUTE_NAME);
        },
      ),
    ];
  }

  StreamBuilder _liveWeatherCard(LocationBloc _locationBloc) {
    return StreamBuilder<SojsonWeather>(
      stream: _locationBloc.locationStream,
      builder: (BuildContext context, AsyncSnapshot<SojsonWeather> snapshot) {
        if(snapshot.hasData) {
          SojsonWeather weather = snapshot.data;
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //天气图标、天气类型名称（晴、阴、小雨。。。）
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getTodayForecastTypeImg(weather.data.forecast[0]),
                            Text(weather.data.forecast[0].type,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        // 温度
                        Center(
                          child: Text('${weather.data.wendu}℃',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 52),),
                        ),
                        IntrinsicWidth(
                          // 湿度、pm2.5、pm10、空气质量
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                  Expanded(flex: 1, child: Text('湿度：'),),
                                  Expanded(flex: 1, child: Text(weather.data.shidu),),
                              ],),
                              Row(children: [
                                Expanded(flex: 1, child: Text('pm2.5：'),),
                                Expanded(flex: 1, child: Text('${weather.data.pm25}'),),
                              ],),
                              Row(children: [
                                Expanded(flex: 1, child: Text('pm10：'),),
                                Expanded(flex: 1, child: Text('${weather.data.pm10}'),),
                              ],),
                              Row(children: [
                                Expanded(flex: 1, child: Text('空气质量：'),),
                                Expanded(flex: 1, child: Text(weather.data.quality),),
                              ],),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Card(child: Image.asset('images/晴.png'),);
        }
      },
    );
  }

 /// 获取天气图标
 Image _getTodayForecastTypeImg(SojsonDetail sojsonDetail) {
   AssetImage assetImage = AssetImage('images/${sojsonDetail.type}.png');
    return Image(
      width: 80,
      height: 80,
      image: assetImage,
    );
 }
}

