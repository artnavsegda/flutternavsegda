import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
      home: _PolygonMapObjectExample(),
    );
  }
}

class _PolygonMapObjectExample extends StatefulWidget {
  @override
  _PolygonMapObjectExampleState createState() =>
      _PolygonMapObjectExampleState();
}

class _PolygonMapObjectExampleState extends State<_PolygonMapObjectExample> {
  final List<MapObject> mapObjects = [
    PolygonMapObject(
      mapId: MapObjectId('polygon'),
      polygon: Polygon(
          outerRing: LinearRing(points: [
            Point(latitude: 59.941879441724176, longitude: 85.62829),
            Point(latitude: 70.12669, longitude: 98.97399),
            Point(latitude: 56.04956, longitude: 125.07751),
          ]),
          innerRings: []),
      strokeColor: Colors.orange[700]!,
      strokeWidth: 3.0,
      fillColor: Colors.yellow[200]!,
      onTap: (PolygonMapObject self, Point point) =>
          print('Tapped me at $point'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: YandexMap(mapObjects: mapObjects)),
        ]);
  }
}
