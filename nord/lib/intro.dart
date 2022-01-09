import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          RiveAnimation.asset(
            'assets/sever.riv',
            fit: BoxFit.cover,
          ),
          Positioned(
              bottom: 48,
              left: 32,
              right: 32,
              child: Text(
                'Легендарные, любимые, особенные.\nТеперь всегда под рукой!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Forum',
                  fontSize: 24,
                ),
              ))
        ],
      ),
    );
  }
}
