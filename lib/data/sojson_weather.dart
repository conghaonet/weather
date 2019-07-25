import 'package:json_annotation/json_annotation.dart';

/// amap_location.g.dart 将在我们运行生成命令后自动生成
part 'sojson_weather.g.dart';

/// https://flutterchina.club/json/
/// 这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()
class SojsonWeather {
  SojsonWeather(this.isAutoLocation, this.time, this.cityInfo, this.date, this.message, this.status, this.data);
  /// 非服务器返回数据，用于标记是否通过定位获取到的城市天气。
  bool isAutoLocation = false;
  /// 系统更新时间, 格式：YYYY-MM-DD HH:mm:ss
  String time;
  SojsonCityInfo cityInfo;
  /// 当前天气的当天日期，数据格式：YYYYMMDD，例：20180922
  String date;
  /// 返回message，返回内容为“Success !”表示成功
  String message;
  /// 返回状态， 返回200时，表示成功
  int status;
  /// 天气数据
  SojsonData data;

  factory SojsonWeather.fromJson(Map<String, dynamic> json) => _$SojsonWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$SojsonWeatherToJson(this);

  @override
  String toString() {
    return "{\"isAutoLocation\":$isAutoLocation,\"time\":\"$time\",\"cityInfo\":${cityInfo.toString()},\"date\":\"$date\",\"message\":\"$message\",\"status\":$status,\"data\":${data.toString()}}";
  }
}

@JsonSerializable()
class SojsonCityInfo {
  SojsonCityInfo(this.city, this.citykey, this.parent, this.updateTime);
  /// 请求城市
  String city;
  /// 请求城市ID
  String citykey;
  /// 所属地区，一般是省份或直辖市
  String parent;
  /// 天气更新时间，格式：hh:mm，例：12:32
  String updateTime;

  factory SojsonCityInfo.fromJson(Map<String, dynamic> json) => _$SojsonCityInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SojsonCityInfoToJson(this);

  @override
  String toString() {
    return "{\"city\":\"$city\",\"citykey\":\"$citykey\",\"parent\":\"$parent\",\"updateTime\":\"$updateTime\"}";
  }

}

@JsonSerializable()
class SojsonData {
  SojsonData(this.shidu, this.pm25, this.pm10, this.quality, this.wendu, this.ganmao, this.yesterday, this.forecast);
  /// 湿度
  String shidu;
  /// pm2.5
  double pm25;
  /// pm10
  double pm10;
  /// 空气质量
  String quality;
  /// 温度
  String wendu;
  /// 感冒提醒（指数）
  String ganmao;
  ///昨日天气
  SojsonDetail yesterday;
  /// 今天+未来14天的天气
  List<SojsonDetail> forecast;

  factory SojsonData.fromJson(Map<String, dynamic> json) => _$SojsonDataFromJson(json);
  Map<String, dynamic> toJson() => _$SojsonDataToJson(this);

  List<SojsonDetail> get allWeathers => [yesterday]..addAll(forecast);

  @override
  String toString() {
    return "{\"shidu\":\"$shidu\",\"pm25\":$pm25,\"pm10\":$pm10,\"quality\":\"$quality\",\"wendu\":\"$wendu\",\"ganmao\":\"$ganmao\",\"yesterday\":${yesterday.toString()},\"forecast\":${forecast.toString()}}";
  }

}

@JsonSerializable()
class SojsonDetail {
  SojsonDetail(this.date, this.ymd, this.week, this.sunrise, this.high, this.low, this.sunset, this.aqi, this.fx, this.fl, this.type, this.notice);

  /// 格式：DD，例：22（表示22日）
  String date;
  /// 年月日，格式：YYYY-MM-DD
  String ymd;
  /// 星期, 例：星期六
  String week;
  /// 日出时间，格式：HHmm，例：04:58
  String sunrise;
  /// 最高温度，例：“高温 26.0℃”
  String high;
  /// 最低温度，例：“温 15.0℃”
  String low;
  /// 日落时间，格式：HHmm，例：19:35
  String sunset;

  double aqi;
  /// 风向，例：西北风
  String fx;
  /// 风力：例：4-5级
  String fl;
  /// 提前类型：晴
  String type;
  /// 提示，例“愿你拥有比阳光明媚的心情”
  String notice;

  factory SojsonDetail.fromJson(Map<String, dynamic> json) => _$SojsonDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SojsonDetailToJson(this);

  int get highNum {
    String strHigh = high.replaceAll('高温', '').replaceAll('℃', '').trim();
    return double.parse(strHigh).toInt();
  }
  int get lowNum {
    String strLow = low.replaceAll('低温', '').replaceAll('℃', '').trim();
    return double.parse(strLow).toInt();
  }
  @override
  String toString() {
    return "{\"date\":\"$date\",\"ymd\":\"$ymd\",\"week\":\"$week\",\"sunrise\":\"$sunrise\",\"high\":\"$high\",\"low\":\"$low\",\"sunset\":\"$sunset\",\"aqi\":$aqi,\"fx\":\"$fx\",\"fl\":\"$fl\",\"type\":\"$type\",\"notice\":\"$notice\"}";
  }

}

@JsonSerializable()
class SojsonError {
  SojsonError(this.time, this.message, this.status);
  String time;
  String message;
  int status;

  factory SojsonError.fromJson(Map<String, dynamic> json) => _$SojsonErrorFromJson(json);
  Map<String, dynamic> toJson() => _$SojsonErrorToJson(this);

  @override
  String toString() {
    return "{\"time\":\"$time\",\"message\":\"$message\",\"status\":$status}";
  }

}
