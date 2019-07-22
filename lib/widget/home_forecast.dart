import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/data/sojson_weather.dart';

class HomeForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocationBloc _locationBloc = BlocProvider.first<LocationBloc>(context);
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<SojsonWeather>(
          stream: _locationBloc.locationStream,
          builder: (BuildContext context, AsyncSnapshot<SojsonWeather> snapshot) {
            if(snapshot.hasData) {
              SojsonWeather _weather = snapshot.data;
              return ListView.separated(
                  itemCount: 1+_weather.data.forecast.length,
                  separatorBuilder: (BuildContext context, int index)  {
                    return Container(width: 1, height: double.infinity, color: Colors.grey,);
                  },
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      color: index ==1 ? Colors.green[400] : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            getWeek(index, _weather),
                            getDate(index, _weather),
                          ],
                        ),
                      ),
                    );
                  }
              );
            } else {
              return Text('no data');
            }
          },
        ),
      ),
    );
  }

  Text getWeek(int index, SojsonWeather _weather) {
    if(index == 0) {
      return Text('昨天');
    } else if(index == 1) {
      return Text('今天');
    } else {
      return Text(_weather.data.forecast[index-1].week);
    }
  }
  Text getDate(int index, SojsonWeather _weather) {
    String strDate;
    if(index == 0) {
      strDate = _weather.data.yesterday.ymd;
    } else {
      strDate = _weather.data.forecast[index-1].ymd;
    }

    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(strDate);
    String formattedDate = DateFormat('M月dd日').format(dateTime);
    return Text(formattedDate);
  }
}