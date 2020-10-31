import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:climatic_my_app/util/utils.dart' as util;
import 'package:http/http.dart' as http;

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {
  String _cityEnter;
  Future _goNextScreen(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    setState(() {
      if (result != null && result.containsKey("enter")) {
        _cityEnter = result['enter'].toString();
      } else {
        print("Nothing");
      }
    });
  }

  Future<Map> getWeather(String api, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$api&units=metric";

    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Climatic"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () => _goNextScreen(context))
        ],
      ),

      //

      body: new Stack(
        children: <Widget>[
          new Center(
              child: new Image.asset(
            "images/umbrella.png",
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,
          )),

          //

          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              "${_cityEnter == null ? util.defalutCity : _cityEnter}",
              style: cityStyle(),
            ),
          ),

          //

          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),

          //

          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 380.0, 0.0, 0.0),
            child: updateTempWidget(_cityEnter),
          )

          //
        ],
      ),
    );
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(util.apId, city == null ? util.defalutCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                //
                new ListTile(
                  title: new Text(content["main"]["temp"].toString(),
                      style: tempStyle()),
                )
              ],
            ),
          );
        } else {
          return new Container();
        }
      },
    );
  }
}

class ChangeCity extends StatefulWidget {
  @override
  _ChangeCityState createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
  var _changecityCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text("Change City "),
        centerTitle: true,
      ),
      body: new Stack(
        children: [
          new Center(
            child: new Image.asset(
              "images/white_snow.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          //

          new ListView(
            children: [
              //
              new ListTile(
                title: new TextField(
                  controller: _changecityCtrl,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(hintText: "Enter City"),
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    onPressed: () {
                      String temData = _changecityCtrl.text == ""
                          ? util.defalutCity
                          : _changecityCtrl.text;

                      Navigator.pop(context, {"enter": temData}); // temp
                    },
                    child: new Text("Get Weather")),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
    fontSize: 22.9,
    color: Colors.white,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    fontSize: 49.9,
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}
