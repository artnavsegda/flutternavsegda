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
          player: Girl(Vector2(40, 40)),
        ),
      ),
    );
  }
}

class Girl extends SimplePlayer {
  Girl(Vector2 position)
      : super(
            position: position,
            size: Vector2(24, 24),
            animation: SimpleDirectionAnimation(
              idleRight: SpriteAnimation.load(
                  'girl/girl.png',
                  SpriteAnimationData.sequenced(
                      texturePosition: Vector2(192, 0),
                      amount: 4,
                      stepTime: 0.1,
                      textureSize: Vector2(24, 24))),
              runRight: SpriteAnimation.load(
                'girl/girl.png',
                SpriteAnimationData.sequenced(
                    texturePosition: Vector2(672, 0),
                    amount: 5,
                    stepTime: 0.1,
                    textureSize: Vector2(24, 24)),
              ),
            ));
}
