import 'package:flutter/material.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/cities_weather_bloc.dart';
import 'package:weather/data/province_city.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/utils/location_util.dart';
import 'package:weather/utils/util.dart';

import '../strings.dart';
import '../translations.dart';


class LocationCityPage extends StatelessWidget {
  static const ROUTE_NAME = "/location_city";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [CitiesWeatherBloc()],
      child: Builder(
        builder: (BuildContext context){
          return _Scaffold();
        },
      ),
    );
  }
}

class _Scaffold extends StatefulWidget {
  @override
  __ScaffoldState createState() => __ScaffoldState();
}

class __ScaffoldState extends State<_Scaffold> {
  Province _newProvince;
  City _newCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).getString(Strings.location_city_title)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
//          BlocProvider.first<CitiesWeatherBloc>(context).addCity("101010300");
          showDialog<void>(context: context, barrierDismissible: true, builder: (BuildContext context){
            return AlertDialog(
              title: Text("添加城市", style: TextStyle(fontSize: 16),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("添加城市a"),
                  FutureBuilder<List<Province>>(
                    future: LocationUtil.getProvincesData(context),
                    builder: (context, snapshot){
                      List<DropdownMenuItem<Province>> dropdownItems = List();
                      if(snapshot.hasData) {
                        dropdownItems.clear();
                        dropdownItems = snapshot.data.map<DropdownMenuItem<Province>>((province) {
                          return DropdownMenuItem<Province>(value: province, child: Text(province.provinceName),);
                        }).toList();
                        _newProvince = snapshot.data[0];
                      }
                      return DropdownButton<Province>(
                        value: _newProvince,
                        items: dropdownItems,
                        onChanged: (selected) {
                          setState(() {
                            _newProvince = selected;
                          });
                        },

                      );
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('添加'),
                  onPressed: () {
//                          BlocProvider.first<CitiesWeatherBloc>(context).delCity("101010900");
                  },
                )
              ],
            );
          },);
        },
      ),
      body: _PageBody(),
    );
  }
}

class _PageBody extends StatefulWidget {
  @override
  __PageBodyState createState() => __PageBodyState();
}

class __PageBodyState extends State<_PageBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  CitiesWeatherBloc _citiesWeatherBloc;
  bool _offstage = false;

  @override
  void initState() {
    super.initState();
/*
    WidgetsBinding.instance.addPostFrameCallback( ( Duration duration ) {
      this._refreshIndicatorKey.currentState.show();
    } );
*/
/*
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      _refreshIndicatorKey.currentState?.show();
    });
*/
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    if(_citiesWeatherBloc == null) {
      _init();
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[500],Colors.green[400],Colors.green[300],],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          StreamBuilder<List<SojsonWeather>>(
            stream: _citiesWeatherBloc.citiesStream,
            builder: (BuildContext context, AsyncSnapshot<List<SojsonWeather>> snapshot) {
              if(snapshot.hasData) {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return getItem(snapshot.data[index]);
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Offstage(
            offstage: _offstage,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  _init() {
    if(_citiesWeatherBloc == null) {
      _citiesWeatherBloc = BlocProvider.first<CitiesWeatherBloc>(context);
      _citiesWeatherBloc.citiesStream.listen((value){
        setState(() {
          _offstage = true;
        });
      });
      _citiesWeatherBloc.errorStream.listen((value){
        setState(() {
          _offstage = true;
        });
        Util.showToast(value.toString());
      }, onError: (e) {
        Util.showToast(e.toString());
      });
      _onRefresh();
    }
  }

  Widget getItem(SojsonWeather _weather) {
    return Container(
      child: Text(_weather.cityInfo.city),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _offstage = false;
    });
    _citiesWeatherBloc.allCitesWeather();
  }
}