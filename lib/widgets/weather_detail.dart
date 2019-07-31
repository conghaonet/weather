import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/sojson_weather.dart';

import 'home_forecast.dart';
class WeatherDetail extends StatefulWidget {
  final SojsonWeather weather;
  final PageController _pageController;
  WeatherDetail(this.weather, this._pageController, {Key key}): super(key: key);
  @override
  _WeatherDetailState createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  var ignoreScroll;
  var _scrollController = ScrollController(initialScrollOffset: 1);
  @override
  void initState() {
    super.initState();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        ignoreScroll = IgnoreScrollFlag.right;
      } else if(_scrollController.position.pixels == 0) {
        ignoreScroll = IgnoreScrollFlag.left;
      } else {
        ignoreScroll = null;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[500],Colors.green[400],Colors.green[300],],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _liveWeatherCard(widget.weather),
            // [Pointer事件处理](https://book.flutterchina.club/chapter8/listener.html)
            Listener(
              behavior: HitTestBehavior.opaque,
              onPointerMove: (PointerMoveEvent event){
//                _log.severe('PointerMoveEvent localDelta.dx: ${event.localDelta.dx}');
                if(ignoreScroll != null) {
                  //滚动到最右或最左边时，自动调用外层PageView的下一页或上一页
                  if(ignoreScroll == IgnoreScrollFlag.right && event.localDelta.dx < 0) {
                    widget._pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.linear);
                  } else if(ignoreScroll == IgnoreScrollFlag.left && event.localDelta.dx > 0) {
                    widget._pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.linear);
                  }
                }
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HomeForecast(weather: widget.weather),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _liveWeatherCard(SojsonWeather weather) {
    return Card(
      color: Colors.green[400],
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //天气图标、天气类型名称（晴、阴、小雨。。。）
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getTodayForecastTypeImg(),
                      Text(widget.weather.data.forecast[0].type,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  // 温度
                  Center(
                    child: Text('${widget.weather.data.wendu}℃',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 52),),
                  ),
                  IntrinsicWidth(
                    // 湿度、pm2.5、pm10、空气质量
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(flex: 1, child: Text('湿度：'),),
                          Expanded(flex: 1, child: Text(widget.weather.data.shidu),),
                        ],),
                        Row(children: [
                          Expanded(flex: 1, child: Text('pm2.5：'),),
                          Expanded(flex: 1, child: Text('${widget.weather.data.pm25}'),),
                        ],),
                        Row(children: [
                          Expanded(flex: 1, child: Text('pm10：'),),
                          Expanded(flex: 1, child: Text('${widget.weather.data.pm10}'),),
                        ],),
                        Row(children: [
                          Expanded(flex: 1, child: Text('空气质量：'),),
                          Expanded(flex: 1, child: Text(widget.weather.data.quality),),
                        ],),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8, bottom: 6,),
              child: Text('温馨提示：${widget.weather.data.ganmao}', style: TextStyle(fontSize: 14),),
            ),
            Text('更新时间：${widget.weather.cityInfo.updateTime}', style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }
  /// 获取天气图标
  Image _getTodayForecastTypeImg() {
    AssetImage assetImage = AssetImage('images/${widget.weather.data.forecast[0].type}.png');
    return Image(
      width: 80,
      height: 80,
      image: assetImage,
    );
  }
}

enum IgnoreScrollFlag {
  left, right, both,
}
