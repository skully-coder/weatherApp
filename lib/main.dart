import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  AppState createState() => AppState();
}

class AppState extends State<MyApp> {
  final apiID = '4443e42762613649bd17dcc113a52e79';
  var defaultCity = 'Manipal';
  var now = new DateTime.now();
  var city;
  void showStuff() async {
    Map data = await getWeather(apiID, defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        primary: true,
        appBar: AppBar(
          title: Text('Klimatic'),
          leading: Icon(Icons.cloud),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Enter City',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            defaultCity = city;
                          });
                        })),
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                },
                keyboardType: TextInputType.text,
              ),
            ),
            displayData(defaultCity),
            new Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0.0, 40.9, 20.9, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_city,
                    size: 30.0,
                  ),
                  new Text(
                    ' $defaultCity',
                    style: cityStyle(),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  new DateFormat("dd-MM-yyyy").format(now),
                  style: TextStyle(fontSize: 40.0, color: Colors.yellow),
                )
              ],
            ),
            displayData2(),
          ],
        ),
      ),
      theme: ThemeData.dark(),
    );
  }

  Widget displayData(var city) {
    return new FutureBuilder(
        future: getWeather(apiID, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        content['main']['temp'].toString() + "°C",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 49.9,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Humidity: ',
                            style: TextStyle(color: Colors.cyan),
                          ),
                          Text(content['main']['humidity'].toString() + "%")
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Max Temp.: ',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            content['main']['temp_max'].toString() + "°C",
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Min Temp.: ',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(content['main']['temp_min'].toString() + "°C")
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                      height: 230.0,
                      width: 230.0,
                      child: CircularProgressIndicator(
                        value: content['main']['humidity'] / 100,
                        valueColor: AlwaysStoppedAnimation(Colors.cyan),
                        strokeWidth: 8.0,
                      )),
                  SizedBox(
                      height: 280.0,
                      width: 280.0,
                      child: CircularProgressIndicator(
                        value: content['main']['temp_min'] /
                            (content['main']['temp_min'] + 10),
                        valueColor: AlwaysStoppedAnimation(Colors.red),
                        strokeWidth: 8.0,
                      )),
                  SizedBox(
                      height: 330.0,
                      width: 330.0,
                      child: CircularProgressIndicator(
                        value: content['main']['temp_max'] /
                            (content['main']['temp_max'] + 5),
                        valueColor: AlwaysStoppedAnimation(Colors.green),
                        strokeWidth: 8.0,
                      ))
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }

  Widget displayData2() {
    return new FutureBuilder(
        future: getWeather(apiID, defaultCity),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Coordinates: ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          Text(content['coord']['lat'].toString() +
                              "°N , " +
                              content['coord']['lon'].toString() +
                              "°E")
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiURL =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId&units=metric';
    http.Response response = await http.get(apiURL);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  TextStyle cityStyle() {
    return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontSize: 30,
    );
  }
}
