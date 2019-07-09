import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //声明一个调用对象，需要把kotlin中注册的ChannelName传入构造函数
  static const _toast = const MethodChannel('app2m.com/toast');
  static const _platform = const MethodChannel('app2m.com/platform');
  static const _location = const MethodChannel('app2m.com/location');
  var _result = '';
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    //注意这里关闭定位服务
    _location.invokeMethod('stopLocation');
    super.dispose();
  }

  //初始化定位监听
  void _initLocation() async {
//    await _amapLocation.init();
  }

  void _getLocation() async {
    try{
      String _city = await _location.invokeMethod('getLocation');
      _toast.invokeMethod('showShortToast', { 'message': _city}); //调用相应方法，并传入相关参数。
    } on PlatformException catch(e, s) {
      print("catch stack====>"+s.toString());
      _toast.invokeMethod('showShortToast', { 'message': e.toString()}); //调用相应方法，并传入相关参数。
    }
  }
  void _incrementCounter() async {
    _getLocation();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
