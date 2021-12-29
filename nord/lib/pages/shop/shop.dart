import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/placeholder/shop.png'),
          Positioned(
            top: 36,
            left: 12,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(32.0, 32.0),
                  shape: CircleBorder(),
                  primary: Colors.white54, // <-- Button color
                  onPrimary: Colors.red, // <-- Splash color
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/Icon-Close.png')),
          )
        ],
      ),
    );
  }
}
