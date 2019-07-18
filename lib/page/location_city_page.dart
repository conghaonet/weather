import 'package:flutter/material.dart';

import '../strings.dart';
import '../translations.dart';


class LocationCityPage extends StatelessWidget {
  static const ROUTE_NAME = "/location_city";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).getString(Strings.location_city_title)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        },
      ),
      body: Container(),
    );
  }

}