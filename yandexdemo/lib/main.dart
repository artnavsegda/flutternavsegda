import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class AddressResult {
  double latitude;
  double longitude;
  String postalCode;

  AddressResult.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        postalCode = json['postal-code'];
}

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
  List<AddressResult> addressResultList = [];
  Future<LocationPermission> geoSettings = Geolocator.checkPermission();

  Future updatePlacemarks() async {
    final cameraPosition = await _controller.getCameraPosition();
    final response = await http.get(
        Uri.https('otpravka-api.pochta.ru', 'postoffice/1.0/nearby', {
          'filter': 'ALL',
          'latitude': cameraPosition.target.latitude.toString(),
          'longitude': cameraPosition.target.longitude.toString(),
        }),
        headers: {
          HttpHeaders.authorizationHeader:
              'AccessToken Yn8h4bGJFQAslJLIhP3cjbyX5OhCeJph',
          'X-User-Authorization':
              'Basic bGV2cmFuYTg4QGdtYWlsLmNvbTpsZXZyYW5hODg='
        });
    final responseJson = await jsonDecode(response.body);
    print(responseJson);
    setState(() {
      addressResultList = List<AddressResult>.from(
          responseJson.map((model) => AddressResult.fromJson(model)));
    });
  }

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
        onCameraPositionChanged: (cameraPosition, reason, finished) {
          if (finished) updatePlacemarks();
        },
        onMapCreated: (controller) async {
          _controller = controller;
          final cameraPosition = await controller.getCameraPosition();
          await controller.moveCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: Point(latitude: 59.9311, longitude: 30.3609),
                  zoom: 10)));
        },
        mapObjects: [
          ...addressResultList.map(
            (addressResult) {
              return PlacemarkMapObject(
                  opacity: 1,
                  icon: PlacemarkIcon.single(PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage(
                          'assets/3.0x/Pin.png'))),
                  mapId: MapObjectId(addressResult.postalCode),
                  point: Point(
                      latitude: addressResult.latitude,
                      longitude: addressResult.longitude));
            },
          ),
          PlacemarkMapObject(
              opacity: 1,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image:
                      BitmapDescriptor.fromAssetImage('assets/3.0x/Pin.png'))),
              mapId: MapObjectId('placemark'),
              point: Point(latitude: 59.945933, longitude: 30.320045)),
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
