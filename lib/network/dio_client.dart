import 'dart:io';

import 'package:dio/dio.dart';

class DioClient {
  static const BASE_API = "http://t.weather.sojson.com/api/weather";
  static final DioClient _dioClient = DioClient._internal();
  Dio _dio = new Dio();
  Dio get dio => _dio;

  factory DioClient() {
    return _dioClient;
  }
  DioClient._internal() {
    _dio.options..receiveTimeout = 10000
    ..connectTimeout = 15000
    ..baseUrl = BASE_API;
    //TODO：设置代理
    setProxy("192.168.2.100", 8888);
//    ..headers['Content-Type'] = 'application/json';

  }
  void setProxy(String proxyServer, int port) {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.findProxy = (uri) {
        return "PROXY $proxyServer:$port";
      };
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
  }
}

DioClient dioClient = DioClient();