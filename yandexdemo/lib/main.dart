import 'dart:convert';
import 'package:geolocator/geolocator.dart';
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
      home: const MapSearchScreen(),
    );
  }
}

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({Key? key}) : super(key: key);

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  late YandexMapController _controller;
  Future<LocationPermission> geoSettings = Geolocator.checkPermission();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          TextButton(onPressed: () {}, child: Text('Самовывоз')),
          TextButton(onPressed: () {}, child: Text('Курьером')),
        ]),
      ),
      body: YandexMap(
        onCameraPositionChanged: (cameraPosition, reason, finished) {},
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
          PolygonMapObject(
            mapId: MapObjectId('polygon'),
            polygon: Polygon(
                outerRing: LinearRing(points: [
                  Point(latitude: 56.34295, longitude: 74.62829),
                  Point(latitude: 70.12669, longitude: 98.97399),
                  Point(latitude: 56.04956, longitude: 125.07751),
                ]),
                innerRings: [
                  LinearRing(points: [
                    Point(latitude: 57.34295, longitude: 78.62829),
                    Point(latitude: 69.12669, longitude: 98.97399),
                    Point(latitude: 57.04956, longitude: 121.07751),
                  ])
                ]),
            strokeColor: Colors.orange[700]!,
            strokeWidth: 3.0,
            fillColor: Colors.yellow[200]!,
            onTap: (PolygonMapObject self, Point point) =>
                print('Tapped me at $point'),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<LocationPermission>(
          future: geoSettings,
          builder: (context, snapshot) {
            return (LocationPermission.always == snapshot.data ||
                    LocationPermission.whileInUse == snapshot.data)
                ? SizedBox.shrink()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        geoSettings = Geolocator.requestPermission();
                      });
                    },
                  );
          }),
    );
  }
}
