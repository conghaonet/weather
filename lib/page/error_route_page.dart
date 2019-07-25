import 'package:flutter/material.dart';

class ErrorRoutePage extends StatefulWidget {
  static const ROUTE_NAME = "/error_route";
  final String route;
  ErrorRoutePage({Key key, this.route}): super(key: key);

  @override
  _ErrorRoutePageState createState() => _ErrorRoutePageState();
}

class _ErrorRoutePageState extends State<ErrorRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('路由错误页面'),
      ),
      body: Container(
        child: Center(
          child: Text('错误路由：${this.widget.route}'),
        ),
      ),
    );
  }
}