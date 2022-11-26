import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Game")),
        body: BonfireWidget(
          joystick: Joystick(
            directional: JoystickDirectional(),
          ),
          map: WorldMapByTiled('tile/map.json'),
          player: Girl(),
        ),
      ),
    );
  }
}

class Girl extends SimplePlayer {
  Girl(Vector2 position) : super(position: position);
}
