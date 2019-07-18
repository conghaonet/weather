import 'package:flutter/material.dart';

import '../strings.dart';
import '../translations.dart';

class SettingsPage extends StatelessWidget {
  static const ROUTE_NAME = "/settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(Translations.of(context).getString(Strings.select_province_label)),

              ],
            ),
          ],
        ),
      ),
    );
  }

}