import 'dart:convert';
import 'package:flutter/services.dart';

import 'data/amap_location.dart';


class AmapChannel {
  MethodChannel _channel = MethodChannel('app2m.com/location');

  Future<AmapLocation> getLocation() {
    return _channel.invokeMethod('getLocation').then((value) {
      Map<String, dynamic> map = jsonDecode(value);
      return AmapLocation.fromJson(map);
    });
  }

  Future<Null> stopLocation() async {
    return await _channel.invokeMethod('stopLocation');
  }

}