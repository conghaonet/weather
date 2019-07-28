// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amap_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmapLocation _$AmapLocationFromJson(Map<String, dynamic> json) {
  return AmapLocation(
    (json['accuracy'] as num)?.toDouble(),
    json['adCode'] as String,
    json['address'] as String,
    (json['altitude'] as num)?.toDouble(),
    json['aoiName'] as String,
    (json['bearing'] as num)?.toDouble(),
    json['buildingId'] as String,
    json['city'] as String,
    json['cityCode'] as String,
    json['conScenario'] as int,
    json['coordType'] as String,
    json['country'] as String,
    json['description'] as String,
    json['district'] as String,
    json['errorCode'] as int,
    json['errorInfo'] as String,
    json['floor'] as String,
    json['gpsAccuracyStatus'] as int,
    (json['latitude'] as num)?.toDouble(),
    json['locationDetail'] as String,
    json['locationType'] as int,
    (json['longitude'] as num)?.toDouble(),
    json['poiName'] as String,
    json['provider'] as String,
    json['province'] as String,
    json['satellites'] as int,
    (json['speed'] as num)?.toDouble(),
    json['street'] as String,
    json['streetNum'] as String,
    json['trustedLevel'] as int,
  );
}

Map<String, dynamic> _$AmapLocationToJson(AmapLocation instance) =>
    <String, dynamic>{
      'accuracy': instance.accuracy,
      'adCode': instance.adCode,
      'address': instance.address,
      'altitude': instance.altitude,
      'aoiName': instance.aoiName,
      'bearing': instance.bearing,
      'buildingId': instance.buildingId,
      'city': instance.city,
      'cityCode': instance.cityCode,
      'conScenario': instance.conScenario,
      'coordType': instance.coordType,
      'country': instance.country,
      'description': instance.description,
      'district': instance.district,
      'errorCode': instance.errorCode,
      'errorInfo': instance.errorInfo,
      'floor': instance.floor,
      'gpsAccuracyStatus': instance.gpsAccuracyStatus,
      'latitude': instance.latitude,
      'locationDetail': instance.locationDetail,
      'locationType': instance.locationType,
      'longitude': instance.longitude,
      'poiName': instance.poiName,
      'provider': instance.provider,
      'province': instance.province,
      'satellites': instance.satellites,
      'speed': instance.speed,
      'street': instance.street,
      'streetNum': instance.streetNum,
      'trustedLevel': instance.trustedLevel,
    };
