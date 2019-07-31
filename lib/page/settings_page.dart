import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class SettingsPage extends StatelessWidget {
  static const ROUTE_NAME = "/settings";
  final _log = Logger('SettingsPage');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        color: Colors.red,
        width: 200,
        height: 200,

        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (PointerDownEvent event) {
            _log.severe('PointerDownEvent: ${event.localDelta.dx}');
          },
          onPointerMove: (PointerMoveEvent event) {
            _log.severe('PointerMoveEvent: ${event.localDelta.dx}');
          },
          child: Container(
            child: Center(
              child: Text('aaaaaaaaaaa',),
            ),
          ),
        ),
      ),
    );
  }

}