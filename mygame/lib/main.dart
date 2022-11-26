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
          //showCollisionArea: true,
          collisionAreaColor: Colors.blue,
          cameraConfig: CameraConfig(zoom: 2.0),
          joystick: Joystick(
            directional: JoystickDirectional(),
          ),
          map: WorldMapByTiled('tile/map.json'),
          //map: WorldMapByTiled('tile/mapa2.json'),
          player: Girl(Vector2(100, 100)),
        ),
      ),
    );
  }
}

class Girl extends SimplePlayer with ObjectCollision {
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
                      stepTime: 0.3,
                      textureSize: Vector2(24, 24))),
              runRight: SpriteAnimation.load(
                'girl/girl.png',
                SpriteAnimationData.sequenced(
                    texturePosition: Vector2(672, 0),
                    amount: 5,
                    stepTime: 0.1,
                    textureSize: Vector2(24, 24)),
              ),
            )) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(size: Vector2.all(24)),
        ],
      ),
    );
  }
}
