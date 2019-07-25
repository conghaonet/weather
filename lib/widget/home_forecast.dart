import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/data/sojson_weather.dart';

class HomeForecast extends StatelessWidget {
  static const _TEMPERATURE_SHAPE_UNIT = 8 ;
  @override
  Widget build(BuildContext context) {
    LocationBloc _locationBloc = BlocProvider.first<LocationBloc>(context);
    return StreamBuilder<SojsonWeather>(
      stream: _locationBloc.locationStream,
      builder: (BuildContext context, AsyncSnapshot<SojsonWeather> snapshot) {
        if(snapshot.hasData) {
          SojsonWeather _weather = snapshot.data;
          List<int> temperatureRange = _getTemperatureRange(_weather);
          List<Widget> columns = List();
          for(int index=0; index< _weather.data.allWeathers.length; index++) {
            columns.add(
              Padding(padding: EdgeInsets.only(left: 6, right: 6), child:
                _getColumn(temperatureRange, index, _weather),)
            );
          }
          return Row(children: columns,);
        } else {
          return Container(child: Text('no data'),);
        }
      },
    );
  }

  Column _getColumn(List<int> temperatureRange, int index, SojsonWeather _weather) {
    return Column(
      children: <Widget>[
        _getWeek(index, _weather),
        _getDate(index, _weather),
        Padding(padding: EdgeInsets.only(top: 16),),
        _getTypeImage(index, _weather),
        Padding(padding: EdgeInsets.only(top: 4),),
        Text(_weather.data.allWeathers[index].type),
        Padding(padding: EdgeInsets.only(top: 16),),
        Text('${_weather.data.allWeathers[index].highNum}℃'),
        Padding(padding: EdgeInsets.only(top: 4),),
        _drawTemperatureShape(temperatureRange, index, _weather),
        Padding(padding: EdgeInsets.only(top: 4),),
        Text('${_weather.data.allWeathers[index].lowNum}℃'),
        Padding(padding: EdgeInsets.only(top: 16),),
        Text(_weather.data.allWeathers[index].fx),
        Padding(padding: EdgeInsets.only(top: 4),),
        Text(_weather.data.allWeathers[index].fl),
        Padding(padding: EdgeInsets.only(top: 8),),
        Image.asset('images/日出.png', width: 30, height: 30,),
        Text(_weather.data.allWeathers[index].sunrise),
        Padding(padding: EdgeInsets.only(top: 8),),
        Image.asset('images/日落.png', width: 30, height: 30,),
        Text(_weather.data.allWeathers[index].sunset),
      ],
    );
  }

  List<int> _getTemperatureRange(SojsonWeather _weather) {
    int highestTemp;
    int lowestTemp;
    for(int i=0; i<_weather.data.allWeathers.length; i++) {
      int intHigh = _weather.data.allWeathers[i].highNum;
      int intLow = _weather.data.allWeathers[i].lowNum;
      if(i == 0) {
        highestTemp = intHigh;
        lowestTemp = intLow;
      } else {
        highestTemp = intHigh > highestTemp ? intHigh : highestTemp;
        lowestTemp = intLow < lowestTemp ? intLow : lowestTemp;
      }
    }
    return [highestTemp, lowestTemp];
  }
  Text _getWeek(int index, SojsonWeather _weather) {
    if(index == 0) {
      return Text('昨天');
    } else if(index == 1) {
      return Text('今天', style: TextStyle(fontWeight: FontWeight.w900),);
    } else {
      return Text(_weather.data.allWeathers[index].week,);
    }
  }
  Text _getDate(int index, SojsonWeather _weather) {
    DateFormat parseDateFormat = DateFormat('yyyy-MM-dd');
    DateFormat formatDateFormat = DateFormat('M月dd日');
    DateTime dateTime = parseDateFormat.parse(_weather.data.allWeathers[index].ymd);
    String formattedDate = formatDateFormat.format(dateTime);
    if(index == 1){
      return Text(formattedDate, style: TextStyle(fontWeight: FontWeight.w900),);
    } else {
      return Text(formattedDate);
    }
  }
  Image _getTypeImage(int index, SojsonWeather _weather) {
    String type = _weather.data.allWeathers[index].type;
    return Image(
      width: 30,
      height: 30,
      image: AssetImage('images/$type.png'),
    );
  }
  Widget _drawTemperatureShape(List<int> range, int index, SojsonWeather _weather) {
    const borderRadius = const BorderRadius.all(const Radius.circular(30.0));
    int topPadding = (range[0] - _weather.data.allWeathers[index].highNum) * _TEMPERATURE_SHAPE_UNIT;
    int bottomPadding = (_weather.data.allWeathers[index].lowNum - range[1]) * _TEMPERATURE_SHAPE_UNIT;
    int shapeHeight = (_weather.data.allWeathers[index].highNum - _weather.data.allWeathers[index].lowNum) * _TEMPERATURE_SHAPE_UNIT;
    int totalHeight = (range[0] - range[1]) * _TEMPERATURE_SHAPE_UNIT;
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: 10.0,
        height: totalHeight.toDouble(),
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding.toDouble(), bottom: bottomPadding.toDouble(),),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              width: 10.0,
              height: shapeHeight.toDouble(),
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}