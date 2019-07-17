
import 'package:flutter/services.dart';


class AmapChannel {
  MethodChannel _channel = MethodChannel('app2m.com/location');

  Future<String> getLocation() async {
    return await _channel.invokeMethod('getLocation');
  }

  Future<Null> stopLocation() async {
    return await _channel.invokeMethod('stopLocation');
  }

}