import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/page/settings_page.dart';
import 'package:weather/translations.dart';
import 'package:weather/strings.dart';
import 'package:weather/utils/permission_util.dart';
import 'package:weather/utils/snack_bar_util.dart';
import 'package:weather/widget/home_forecast.dart';

import 'location_city_page.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocationBloc _locationBloc = BlocProvider.first<LocationBloc>(context);
//    _requestLocation(context);
    return Scaffold(
      key: _scaffoldKey,
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
                      _requestLocation(context);
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
      body: HomePageBody(),
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


}

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocationBloc _locationBloc = BlocProvider.first<LocationBloc>(context);
    _requestLocation(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
//      color: Theme.of(context).primaryColor,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[500],Colors.green[400],Colors.green[300],],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _liveWeatherCard(_locationBloc),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: HomeForecast(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  StreamBuilder _liveWeatherCard(LocationBloc _locationBloc) {
    return StreamBuilder<SojsonWeather>(
      stream: _locationBloc.locationStream,
      builder: (BuildContext context, AsyncSnapshot<SojsonWeather> snapshot) {
        if(snapshot.hasData) {
          SojsonWeather weather = snapshot.data;
          return Card(
            color: Colors.green[400],
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
                  Padding(padding: EdgeInsets.only(top: 8, bottom: 6,),
                    child: Text('温馨提示：${weather.data.ganmao}', style: TextStyle(fontSize: 14),),
                  ),
                  Text('更新时间：${weather.cityInfo.updateTime}', style: TextStyle(fontSize: 12),),
                ],
              ),
            ),
          );
        } else {
          return Container();
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

_requestLocation(BuildContext context) async {
  LocationBloc _locationBloc = BlocProvider.first<LocationBloc>(context);
  String prompt = Translations.of(context).getString(Strings.permission_prompt_location);
  SnackBarAction action = AppSnackBarAction.getDefaultPermissionAction(context);
  PermissionGroup deniedPermission = await PermissionUtil.requestPermissions(_scaffoldKey.currentState, [PermissionGroup.location, PermissionGroup.storage], prompt, action: action);
  if(deniedPermission != PermissionGroup.location) {
    _locationBloc.autoLocationWeather();
  } else {
    bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(deniedPermission);
    if(isShown) {
      SnackBarAction _action = SnackBarAction(
        label: 'ok',
        onPressed: () {
          _requestLocation(context);
        },
      );
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(prompt),
          action: _action,
        )
      );
    }
  }
}
