import 'package:json_annotation/json_annotation.dart';

/// amap_location.g.dart 将在我们运行生成命令后自动生成
part 'amap_location.g.dart';

/// https://flutterchina.club/json/
/// 这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()

class AmapLocation{
  AmapLocation(this.accuracy, this.adCode, this.address, this.altitude, this.aoiName, this.bearing, this.buildingId, this.city, this.cityCode,
      this.conScenario, this.coordType, this.country, this.description, this.district, this.errorCode, this.errorInfo, this.floor, this.latitude,
      this.locationDetail, this.locationType, this.longitude, this.poiName, this.provider, this.province, this.satellites, this.speed, this.street,
      this.streetNum, this.trustedLevel);
  /// 获取定位精度 单位:米
  double accuracy;
  /// 获取区域编码
  String adCode;
  /// 获取地址
  String address;
  /// 获取海拔高度(单位：米) 默认值：0.0
  double altitude;
  /// 获取兴趣面名称
  String aoiName;
  /// 获取方向角(单位：度） 默认值：0.0
  double bearing;
  /// 返回支持室内定位的建筑物ID信息
  String buildingId;
  /// 城市名称
  String city;
  /// 城市编码
  String cityCode;
  /// 室内外置信度 室内：且置信度取值在[1 ～ 100]，值越大在在室内的可能性越大
  /// 室外：且置信度取值在[-100 ～ -1] ,值越小在在室内的可能性越大 无法识别室内外：置信度返回值为 0
  int conScenario;
  /// 获取坐标系类型 高德定位sdk会返回两种坐标系
  /// AMapLocation.COORD_TYPE_GCJ02 -- GCJ02坐标系
  /// AMapLocation.COORD_TYPE_WGS84 -- WGS84坐标系,国外定位时返回的是WGS84坐标系
  String coordType;
  /// 国家名称
  String country;
  /// 位置语义信息
  String description;
  /// 获取区的名称
  String district;
  /// 错误码
  int errorCode;
  /// 错误信息
  String errorInfo;
  /// 室内定位的楼层信息
  String floor;
  /// 纬度
  double latitude;
  /// 定位信息描述
  String locationDetail;
  /// 定位结果来源
  int locationType;
  /// 经度
  double longitude;
  /// 兴趣点名称
  String poiName;
  /// 定位提供者
  String provider;
  /// 省的名称
  String province;
  /// 当前可用卫星数量, 仅在卫星定位时有效
  int satellites;
  /// 获取当前速度(单位：米/秒) 默认值：0.0
  double speed;
  /// 街道名称
  String street;
  /// 门牌号
  String streetNum;
  /// 获取定位结果的可信度 只有在定位成功时才有意义
  /// 非常可信 AMapLocation.TRUSTED_LEVEL_HIGH
  /// 可信度一般AMapLocation.TRUSTED_LEVEL_NORMAL
  /// 可信度较低 AMapLocation.TRUSTED_LEVEL_LOW
  /// 非常不可信 AMapLocation.TRUSTED_LEVEL_BAD
  int trustedLevel;

  /// 不同的类使用不同的mixin即可
  factory AmapLocation.fromJson(Map<String, dynamic> json) => _$AmapLocationFromJson(json);
  Map<String, dynamic> toJson() => _$AmapLocationToJson(this);

}