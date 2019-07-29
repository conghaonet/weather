import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/cities_weather_bloc.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/common/my_visibility.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/page/settings_page.dart';
import 'package:weather/translations.dart';
import 'package:weather/strings.dart';
import 'package:weather/utils/permission_util.dart';
import 'package:weather/utils/snack_bar_util.dart';
import 'package:weather/utils/util.dart';
import 'package:weather/widgets/weather_detail.dart';

import '../exceptions.dart';
import 'location_city_page.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger _log = Logger("_HomePageState");
  final List<SojsonWeather> _weathers = [];
  int currentPageIndex;
  LocationBloc _locationBloc;
  PageController _pageController;
  CitiesWeatherBloc _citiesWeatherBloc;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_citiesWeatherBloc == null) {
      _citiesWeatherBloc = BlocProvider.first<CitiesWeatherBloc>(context);
      _citiesWeatherBloc.citiesStream.listen((weathers){
        setState(() {
          _weathers.clear();
          _weathers.addAll(weathers);
          if(currentPageIndex == null && _weathers.isNotEmpty) {
            currentPageIndex = 0;
          }
        });
      });
      _citiesWeatherBloc.allCitesWeather();
    }

    if(_locationBloc == null) {
      _locationBloc = BlocProvider.first<LocationBloc>(context);
/*
      _locationBloc.errorStream.listen((value) {
      }, onError: (e) {
        if(e is MyBaseException) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(e.message),
            action: SnackBarAction(label: 'ok', onPressed: (){}),
          ));
        } else {
          Util.showToast(e.toString());
        }
      }, cancelOnError: false);
      _requestLocation(context);
*/
    }
  }
  void updateAppBar(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            MyVisibility(
              flag: this.currentPageIndex != null
                  ? (_weathers[currentPageIndex].isAutoLocation ? MyVisibilityFlag.VISIBLE: MyVisibilityFlag.INVISIBLE)
                  : MyVisibilityFlag.INVISIBLE,
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  _requestLocation(context);
                },
              ),
            ),
            Text(
                this.currentPageIndex != null
                    ? _weathers[currentPageIndex].cityInfo.city
                    : Translations.of(context).getString(Strings.app_name)
            ),
          ],
        ),
        actions: _getAppBarActions(context),
      ),
      body: Container(
        child: PageView(
          onPageChanged: (pageIndex) {
            updateAppBar(pageIndex);
          },
          controller: _pageController,
          children: _weathers.map((weather) {
            return WeatherDetail(weather);
          }).toList(),
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
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

_requestLocation(BuildContext context) async {
  String prompt = Translations.of(context).getString(Strings.permission_prompt_location);
  SnackBarAction action = AppSnackBarAction.getDefaultPermissionAction(context);
  PermissionGroup deniedPermission = await PermissionUtil.requestPermissions(_scaffoldKey.currentState, [PermissionGroup.location, PermissionGroup.storage], prompt, action: action);
  if(deniedPermission != PermissionGroup.location) {
    BlocProvider.first<LocationBloc>(context).autoLocationWeather();
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
