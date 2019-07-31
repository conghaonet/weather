import 'package:flutter/material.dart';
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

import '../event_bus.dart';
import '../exceptions.dart';
import 'location_city_page.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final List<SojsonWeather> _weathers = [];
  int currentPageIndex;
  bool isLoading = false;
  LocationBloc _locationBloc;
  PageController _pageController;
  CitiesWeatherBloc _citiesWeatherBloc;
  @override
  void initState() {
    super.initState();
    //注册widget监听，复写时要在super之后
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(
      initialPage: 0,
    );
    //监听点击城市事件
    bus.on(LocationCityPage.EVENT_NAME_CHANGE_CITY, (dynamic pageIndex) {
      _pageController.jumpToPage(pageIndex);
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_locationBloc == null) {
      _locationBloc = BlocProvider.first<LocationBloc>(context);
      _locationBloc.locationStream.listen((event){
        if(event != null) {
          _citiesWeatherBloc.allCitesWeather();
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        if(e is MyBaseException) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(e.message),
            action: SnackBarAction(label: 'ok', onPressed: (){}),
          ));
        } else {
          Util.showToast(e.toString());
        }
      });
    }
    if(_citiesWeatherBloc == null) {
      _citiesWeatherBloc = BlocProvider.first<CitiesWeatherBloc>(context);
      _citiesWeatherBloc.citiesStream.listen((weathers){
        setState(() {
          _weathers.clear();
          _weathers.addAll(weathers);
          if(currentPageIndex == null) {
            if(_weathers.isNotEmpty) currentPageIndex = 0;
          } else {
            if(_weathers.isEmpty) {
              currentPageIndex = null;
            } else {
              if(currentPageIndex >= _weathers.length) {
                currentPageIndex = _weathers.length-1;
              }
            }
          }
          var locationWeather;
          if(_weathers.isNotEmpty) {
            locationWeather = _weathers.singleWhere((weather) {
              return weather.isAutoLocation;
            }, orElse: null);
          }
          if(locationWeather == null) {
            //更新当前位置的天气预报
            _requestLocation(context);
          } else {
            isLoading =false;
          }
        });
      }, onError: (e) {
        Util.showToast(e.toString());
        setState(() {
          isLoading = false;
        });
      });
      _citiesWeatherBloc.allCitesWeather();
      isLoading = true;
    }
  }
  void updateAppBar(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
    });
  }
  /// Widget状态变更监听方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('Observer--可见没有响应inactive');
        break;
      case AppLifecycleState.paused:
        print('Observer--不可见不响应paused');
        break;
      case AppLifecycleState.resumed:
        print('Observer--可见可交互resumed');
        break;
      case AppLifecycleState.suspending:
        print('Observer--申请暂停suspending');
        break;
    }
    super.didChangeAppLifecycleState(state);
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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey, Colors.grey[400], Colors.grey[300],],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            ),
            child: Center(
              child: FlatButton(
                onPressed: () {
                  _citiesWeatherBloc.allCitesWeather();
                  setState(() {
                    isLoading = true;
                  });
                },
                child: Text('重试'),),
            ),
          ),
          Offstage(
            offstage: !isLoading,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[500], Colors.green[400], Colors.green[300]],
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              ),
            ),
          ),
          Offstage(
            offstage: _weathers == null || _weathers.isEmpty,
            child: PageView(
              onPageChanged: (pageIndex) {
                updateAppBar(pageIndex);
              },
              controller: _pageController,
              children: _weathers.map((weather) {
                return WeatherDetail(weather, _pageController);
              }).toList(),
            ),
          ),
        ],
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
    bus.off(LocationCityPage.EVENT_NAME_CHANGE_CITY);
    super.dispose();
  }
}

_requestLocation(BuildContext context) async {
  String prompt = Translations.of(context).getString(Strings.permission_prompt_location);
  SnackBarAction action = AppSnackBarAction.getDefaultPermissionAction(context);
  PermissionGroup deniedPermission = await PermissionUtil.requestPermissions(_scaffoldKey.currentState, [PermissionGroup.location, PermissionGroup.storage], prompt, action: action);
  if(deniedPermission != PermissionGroup.location) {
    BlocProvider.first<LocationBloc>(context).myLocationWeather();
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
