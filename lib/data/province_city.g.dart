// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Province _$ProvinceFromJson(Map<String, dynamic> json) {
  return Province(
      json['provinceCode'] as String,
      json['provinceName'] as String,
      (json['cities'] as List)
          ?.map((e) =>
              e == null ? null : City.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ProvinceToJson(Province instance) => <String, dynamic>{
      'provinceCode': instance.provinceCode,
      'provinceName': instance.provinceName,
      'cities': instance.cities
    };

City _$CityFromJson(Map<String, dynamic> json) {
  return City(json['cityCode'] as String, json['cityName'] as String);
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityCode': instance.cityCode,
      'cityName': instance.cityName
    };
