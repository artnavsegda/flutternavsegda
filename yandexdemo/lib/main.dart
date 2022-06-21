import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late YandexMapController _controller;

  Future updatePlacemarks() async {
    final response = await http.get(
        Uri.https('otpravka-api.pochta.ru', 'postoffice/1.0/nearby', {
          'filter': 'ALL',
          'latitude': '59.937500',
          'longitude': '30.308611',
        }),
        headers: {
          HttpHeaders.authorizationHeader:
              'AccessToken Yn8h4bGJFQAslJLIhP3cjbyX5OhCeJph',
          'X-User-Authorization':
              'Basic bGV2cmFuYTg4QGdtYWlsLmNvbTpsZXZyYW5hODg='
        });
    final responseJson = await jsonDecode(response.body);
    print(responseJson);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: YandexMap(
        onMapCreated: (controller) async {
          _controller = controller;
          final cameraPosition = await controller.getCameraPosition();
          await controller.moveCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: Point(latitude: 59.9311, longitude: 30.3609),
                  zoom: 10)));
        },
        mapObjects: [
          PlacemarkMapObject(
              opacity: 1,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image:
                      BitmapDescriptor.fromAssetImage('assets/3.0x/Pin.png'))),
              mapId: MapObjectId('placemark'),
              point: Point(latitude: 59.945933, longitude: 30.320045)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
