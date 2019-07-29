import 'package:flutter/material.dart';
import 'package:weather/bloc/bloc_provider.dart';
import 'package:weather/bloc/cities_weather_bloc.dart';
import 'package:weather/common/my_visibility.dart';
import 'package:weather/data/province_city.dart';
import 'package:weather/data/sojson_weather.dart';
import 'package:weather/utils/location_util.dart';
import 'package:weather/utils/util.dart';

import '../strings.dart';
import '../translations.dart';

class Model {
  String cityCode;
  int provinceIndex;
  List<Province> provinces;
  List<SojsonWeather> weathers;
}

class LocationCityPage extends StatefulWidget {
  static const ROUTE_NAME = "/location_city";
  @override
  _LocationCityPageState createState() => _LocationCityPageState();
}

class _LocationCityPageState extends State<LocationCityPage> {
  final Model _model = Model();
  @override
  void initState() {
    super.initState();
    BlocProvider.first<CitiesWeatherBloc>(context).citiesStream.listen((value){
      _model.weathers = value;
    });  }
  void onAddCity() {
    for(SojsonWeather weather in _model.weathers) {
      if(weather.cityInfo.citykey == _model.cityCode) {
        Util.showToast("【${weather.cityInfo.city}】已存在，不可重复添加。");
        return;
      }
    }
    BlocProvider.first<CitiesWeatherBloc>(context).addCity(_model.cityCode);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).getString(Strings.location_city_title)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog<void>(context: context, barrierDismissible: true, builder: (BuildContext context){
            return AlertDialog(
              title: Text("添加城市", style: TextStyle(fontSize: 16),),
              content: ProvinceDropdown(model: _model,),
              actions: <Widget>[
                FlatButton(
                  child: Text('添加'),
                  onPressed: () {
                    onAddCity();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },);
        },
      ),
      body: _PageBody(),
    );
  }
}

class ProvinceDropdown extends StatefulWidget {
  final Model model;
  ProvinceDropdown({Key key, this.model}): super(key: key);
  @override
  _ProvinceDropdownState createState() => _ProvinceDropdownState();
}
class _ProvinceDropdownState extends State<ProvinceDropdown> {
  List<DropdownMenuItem<String>> getCities() {
    if(widget.model == null || widget.model.provinceIndex == null) return null;
    else {
      return widget.model.provinces[widget.model.provinceIndex ].cities.map(
              (city) => DropdownMenuItem<String>(value: city.cityCode, child: Text(city.cityName),)
      ).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<List<Province>>(
          future: LocationUtil.getProvincesData(context),
          builder: (context, snapshot){
            List<DropdownMenuItem<int>> dropdownItems = [];
            if(snapshot.hasData) {
              widget.model.provinces = snapshot.data;
              dropdownItems = List.generate(snapshot.data.length, (index){
                return DropdownMenuItem<int>(value: index, child: Text(snapshot.data[index].provinceName),);
              });
            }
            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: DropdownButton<int>(
                isExpanded: true,
                value: widget.model.provinceIndex,
                hint: Text('——请选择省——'),
                items: dropdownItems,
                onChanged: (selected) {
                  setState(() {
                    if(widget.model.provinceIndex != selected) {
                      widget.model.cityCode = null;
                      widget.model.provinceIndex = selected;
                    }
                  });
                },
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: DropdownButton<String>(
            isExpanded: true,
            value: widget.model.cityCode,
            hint: Text('——请选择市——'),
            items: getCities(),
            onChanged: (selected) {
              setState(() {
                widget.model.cityCode = selected;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _PageBody extends StatefulWidget {
  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<_PageBody> {
  CitiesWeatherBloc _citiesWeatherBloc;
  List<SojsonWeather> _allWeathers;
  bool _offstage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  _init() {
    if(_citiesWeatherBloc == null) {
      _citiesWeatherBloc = BlocProvider.first<CitiesWeatherBloc>(context);
      _citiesWeatherBloc.citiesStream.listen((value){
        if(mounted) {
          setState(() {
            _offstage = true;
          });
        }
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
                _allWeathers = snapshot.data;
                return RefreshIndicator(
                  onRefresh: () => _onRefresh(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Util.showToast(snapshot.data[index].cityInfo.city);
                            print('点击事件：${snapshot.data[index].cityInfo.city}');
                          },
                          child: getItem(index, snapshot.data[index]),);
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Offstage(
            offstage: _offstage,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget getItem(int index, SojsonWeather _weather) {
    var itemWidget = Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white70,
            height: index == 0 ? 0 : 1,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8,),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MyVisibility(
                  flag: _weather.isAutoLocation ? MyVisibilityFlag.VISIBLE : MyVisibilityFlag.INVISIBLE,
                  child: const Icon(Icons.location_on, color: Colors.white70, size: 24,),
                ),
                Text(_weather.cityInfo.city, style: TextStyle(fontSize: 24),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 8,),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${_weather.data.wendu}℃', style: TextStyle(fontSize: 24),),
              ],
            ),
          ),
        ],
      ),
    );
    return Dismissible(
      //如果Dismissible是一个列表项 它必须有一个key 用来区别其他项
      key: Key(_weather.cityInfo.citykey),
      child: itemWidget,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
        ),
      ),
      // 返回true时，执行删除动作。
      confirmDismiss: (direction) async {
        if(index >0) {
          bool isDel = await showConfirmDeleteDialog(_weather);
          if(isDel) {
            _allWeathers.remove(index);
            BlocProvider.first<CitiesWeatherBloc>(context).delCity(_weather.cityInfo.citykey);
            return true;
          } else {
            return false;
          }
        } else {
          Util.showToast('自动定位的城市，无法手动删除');
          return false;
        }
      },
      onDismissed: (direction) {
        _allWeathers.remove(index);
        BlocProvider.first<CitiesWeatherBloc>(context).delCity(_weather.cityInfo.citykey);
      },
    );
  }

  /// 弹出确认删除的对话框
  Future<bool> showConfirmDeleteDialog(SojsonWeather _weather) async {
    bool isConfirm = await showDialog(context: context, builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('确认删除【${_weather.cityInfo.city}】?'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop<bool>(context, false);
            },
            child: const Text('取消', style: TextStyle(color: Colors.black),),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop<bool>(context, true);
            },
            child: const Text('删除', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    });
    // isConfirm是bool类型，dart中bool可为null。isConfirm如为null，则返回false；
    return isConfirm ?? false;
  }
  Future<void> _onRefresh() async {
    setState(() {
      _offstage = false;
    });
    _citiesWeatherBloc.allCitesWeather();
  }
}