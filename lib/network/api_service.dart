import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../data/sojson_weather.dart';

class ApiService {
  static Future<SojsonWeather> getCityWeather(String cityId) async {
    Response<Map<String, dynamic>> response = await dioClient.dio.get("/city/$cityId");
    return SojsonWeather.fromJson(response.data);
  }
}