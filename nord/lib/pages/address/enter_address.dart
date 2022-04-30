import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EnterAddress extends StatelessWidget {
  const EnterAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Введите адрес')),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: Text('Сохранить')),
          TextField(),
          TextField(),
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
          ),
        ],
      ),
    );
  }
}
