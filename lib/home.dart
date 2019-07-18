import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'bloc/application_bloc.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/location_bloc.dart';
import 'data/amap_location.dart';
import 'translations.dart';
import 'application.dart';
import 'strings.dart';
import 'utils/permission_util.dart';
import 'utils/snack_bar_util.dart';
import 'utils/util.dart';
import 'bloc/cities_page_bloc.dart';
import 'data/province_city.dart';

class HomePage extends StatelessWidget {
  LocationBloc _locationBloc;
  @override
  Widget build(BuildContext context) {
    _locationBloc = BlocProvider.first<LocationBloc>(context);
    _locationBloc.locationCity();
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).getString(Strings.appName),),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {

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