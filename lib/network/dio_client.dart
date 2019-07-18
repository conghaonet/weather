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
    _dio.options.receiveTimeout = 10000;
    _dio.options.connectTimeout = 15000;
    _dio.options.baseUrl = BASE_API;
  }
}

DioClient dioClient = DioClient();