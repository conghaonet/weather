// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sojson_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SojsonWeather _$SojsonWeatherFromJson(Map<String, dynamic> json) {
  return SojsonWeather(
      json['time'] as String,
      json['cityInfo'] == null
          ? null
          : SojsonCityInfo.fromJson(json['cityInfo'] as Map<String, dynamic>),
      json['date'] as String,
      json['message'] as String,
      json['status'] as int,
      json['data'] == null
          ? null
          : SojsonData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SojsonWeatherToJson(SojsonWeather instance) =>
    <String, dynamic>{
      'time': instance.time,
      'cityInfo': instance.cityInfo,
      'date': instance.date,
      'message': instance.message,
      'status': instance.status,
      'data': instance.data
    };

SojsonCityInfo _$SojsonCityInfoFromJson(Map<String, dynamic> json) {
  return SojsonCityInfo(json['city'] as String, json['cityId'] as String,
      json['parent'] as String, json['updateTime'] as String);
}

Map<String, dynamic> _$SojsonCityInfoToJson(SojsonCityInfo instance) =>
    <String, dynamic>{
      'city': instance.city,
      'cityId': instance.cityId,
      'parent': instance.parent,
      'updateTime': instance.updateTime
    };

SojsonData _$SojsonDataFromJson(Map<String, dynamic> json) {
  return SojsonData(
      json['shidu'] as String,
      (json['pm25'] as num)?.toDouble(),
      (json['pm10'] as num)?.toDouble(),
      json['quality'] as String,
      json['wendu'] as String,
      json['ganmao'] as String,
      json['yesterday'] == null
          ? null
          : SojsonDetail.fromJson(json['yesterday'] as Map<String, dynamic>),
      (json['forecast'] as List)
          ?.map((e) => e == null
              ? null
              : SojsonDetail.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SojsonDataToJson(SojsonData instance) =>
    <String, dynamic>{
      'shidu': instance.shidu,
      'pm25': instance.pm25,
      'pm10': instance.pm10,
      'quality': instance.quality,
      'wendu': instance.wendu,
      'ganmao': instance.ganmao,
      'yesterday': instance.yesterday,
      'forecast': instance.forecast
    };

SojsonDetail _$SojsonDetailFromJson(Map<String, dynamic> json) {
  return SojsonDetail(
      json['date'] as String,
      json['ymd'] as String,
      json['week'] as String,
      json['sunrise'] as String,
      json['high'] as String,
      json['low'] as String,
      json['sunset'] as String,
      (json['aqi'] as num)?.toDouble(),
      json['fx'] as String,
      json['fl'] as String,
      json['type'] as String,
      json['notice'] as String);
}

Map<String, dynamic> _$SojsonDetailToJson(SojsonDetail instance) =>
    <String, dynamic>{
      'date': instance.date,
      'ymd': instance.ymd,
      'week': instance.week,
      'sunrise': instance.sunrise,
      'high': instance.high,
      'low': instance.low,
      'sunset': instance.sunset,
      'aqi': instance.aqi,
      'fx': instance.fx,
      'fl': instance.fl,
      'type': instance.type,
      'notice': instance.notice
    };

SojsonError _$SojsonErrorFromJson(Map<String, dynamic> json) {
  return SojsonError(
      json['time'] as String, json['message'] as String, json['status'] as int);
}

Map<String, dynamic> _$SojsonErrorToJson(SojsonError instance) =>
    <String, dynamic>{
      'time': instance.time,
      'message': instance.message,
      'status': instance.status
    };
