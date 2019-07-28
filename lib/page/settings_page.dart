import 'package:flutter/material.dart';
import 'package:weather/data/province_city.dart';
import 'package:weather/utils/location_util.dart';

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[500],Colors.green[400],Colors.green[300],],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(Translations.of(context).getString(Strings.select_province_label)),

              ],
            ),
            MyDropdown(),
          ],
        ),
      ),
    );
  }
}

class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  int selected;
  List<String> values;
  List<DropdownMenuItem<String>> items;
  @override
  void initState() {
    super.initState();
  }
/*
  Future<List<String>> buiItems() async {
    values = ['A','B','C'];
    selected = values[0];
    items = values.map((value) => DropdownMenuItem<String>(value: value, child: Text(value),)).toList();
    return values;
  }
*/
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Province>>(
      future: LocationUtil.getProvincesData(context),
      builder: (context, snapshot){
        if(snapshot.hasData) {
          List<DropdownMenuItem<int>> itemList = List.generate(snapshot.data.length, (index){
            return DropdownMenuItem<int>(value: index, child: Text(snapshot.data[index].provinceName),);
          });
//          List<DropdownMenuItem<int>> itemList = snapshot.data.map((province) => DropdownMenuItem(value: province, child: Text(province.provinceName),)).toList();
          return DropdownButton<int>(
            value: selected ?? itemList[0].value,
            items: itemList,
            onChanged: (_selected) {
              setState(() {
                selected =_selected;
              });
            },
          );
        } else {
          return Container();
        }
      },
    );


  }
}