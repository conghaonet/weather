import 'package:json_annotation/json_annotation.dart';

/// province_city.g.dart 将在我们运行生成命令后自动生成
part 'province_city.g.dart';

/// https://flutterchina.club/json/
/// 这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()
class Province {
  Province(this.provinceCode, this.provinceName, this.cities);
  String provinceCode;
  String provinceName;
  List<City> cities;

  /// 不同的类使用不同的mixin即可
  factory Province.fromJson(Map<String, dynamic> json) => _$ProvinceFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinceToJson(this);

  @override
  String toString() {
    return "{\"provinceCode\":\"$provinceCode\",\"provinceName\":\"$provinceName\",\"cities\":${cities.toString()}}";
  }
}

@JsonSerializable()
class City {
  City(this.cityCode, this.cityName);
  String cityCode;
  String cityName;
  /// 不同的类使用不同的mixin即可
  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);

  @override
  String toString() {
    return "{\"cityCode\":\"$cityCode\",\"cityName\":\"$cityName\"}";
  }
}