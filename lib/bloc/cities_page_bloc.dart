import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

import '../data/province_city.dart';
import 'bloc_provider.dart';

class CitiesPageBloc extends BlocBase {
  final _provincesController = StreamController<List<Province>>();
  StreamSink<List<Province>> get _provinceSink => _provincesController.sink;
  Stream<List<Province>> get provinceStream => _provincesController.stream;

  final List<Province> _provinces = new List();
  CitiesPageBloc() {
    _initProvinces();
  }


/*
  void getAllProvinces() {
    _initProvinces();
  }
*/

  void _initProvinces() async {
    if(_provinces.isNotEmpty) {
      _provinceSink.add(_provinces);
    }
    String json = await rootBundle.loadString('assets/cities.json');
    List<dynamic> listDynamic = jsonDecode(json);
    List<Province> provinces = listDynamic.map((js) =>Province.fromJson(js)).toList();
    _provinces..clear()..addAll(provinces);
    _provinceSink.add(_provinces);
  }

  @override
  void dispose() {
    _provincesController.close();
  }

}