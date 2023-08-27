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
        body: BonfireWidget(
          //showCollisionArea: true,
          collisionAreaColor: Colors.blue,
          cameraConfig: CameraConfig(zoom: 2.0),
          joystick: JoystickMoveToPosition(
            enabledMoveCameraWithClick: false,
            mouseButtonUsedToMoveToPosition: MouseButton.left,
          ),
          map: WorldMapByTiled(
            'tile/map.json',
            objectsBuilder: {
              'chicken': (properties) => Chicken(properties.position),
              'cat': (properties) => Cat(properties.position),
            },
          ),
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

class Chicken extends SimpleEnemy with ObjectCollision {
  Chicken(Vector2 position)
      : super(
            position: position,
            size: Vector2(12, 12),
            animation: SimpleDirectionAnimation(
              idleRight: SpriteAnimation.load(
                  'chicken.png',
                  SpriteAnimationData.sequenced(
                      amount: 3, stepTime: 0.5, textureSize: Vector2(12, 12))),
              runRight: SpriteAnimation.load(
                'chicken.png',
                SpriteAnimationData.sequenced(
                    amount: 2, stepTime: 0.1, textureSize: Vector2(12, 12)),
              ),
            )) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(size: Vector2.all(12)),
        ],
      ),
    );
  }
}

class Cat extends SimpleEnemy with ObjectCollision {
  Cat(Vector2 position)
      : super(
            position: position,
            size: Vector2(32, 32),
            animation: SimpleDirectionAnimation(
              idleRight: SpriteAnimation.load(
                  'cat.png',
                  SpriteAnimationData.sequenced(
                      amount: 15, stepTime: 0.3, textureSize: Vector2(32, 32))),
              runRight: SpriteAnimation.load(
                'cat.png',
                SpriteAnimationData.sequenced(
                    amount: 15, stepTime: 0.1, textureSize: Vector2(32, 32)),
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
