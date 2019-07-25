import 'package:flutter/material.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/cities_weather_bloc.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/utils/util.dart';

import '../strings.dart';
import '../translations.dart';


class LocationCityPage extends StatelessWidget {
  static const ROUTE_NAME = "/location_city";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [CitiesWeatherBloc()],
      child: _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
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
        },
      ),
      body: _PageBody(),
    );
  }

}

class _PageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.first<CitiesWeatherBloc>(context).errorStream.listen((e){
      Util.showToast(e.toString());
    });
    BlocProvider.first<CitiesWeatherBloc>(context).allCitesWeather();
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
      child: StreamBuilder<List<SojsonWeather>>(
        stream: BlocProvider.first<CitiesWeatherBloc>(context).citiesStream,
        builder: (BuildContext context, AsyncSnapshot<List<SojsonWeather>> snapshot) {
          if(snapshot.hasData) {
             return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return getItem(snapshot.data[index]);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
  
  Widget getItem(SojsonWeather _weather) {
    return Container(
      child: Text(_weather.cityInfo.city),
    );
  }

}