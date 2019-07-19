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
  LocationBloc _locationBloc;
  @override
  Widget build(BuildContext context) {
    _locationBloc = BlocProvider.first<LocationBloc>(context);
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
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            MaterialButton(
              child: Text(Translations.of(context).getString(Strings.location)),
              onPressed: () {
                BlocProvider.first<ApplicationBloc>(context).onChangeLocale(Locale('zh'));

              },
            ),
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
}