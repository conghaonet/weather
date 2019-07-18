import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'package:weather/bloc/application_bloc.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/data/amap_location.dart';
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
    _locationBloc.locationCity();
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).getString(Strings.app_name),),
        actions: <Widget>[
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
        ],
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
            StreamBuilder<City>(
              stream: _locationBloc.locationStream,
              builder: (BuildContext context, AsyncSnapshot<City> snapshot) {
                if(snapshot.hasData) {
                  return Text('当前城市：${snapshot.data.cityName}');
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

}