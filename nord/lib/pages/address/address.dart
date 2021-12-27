import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Адрес доставки или кафе'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Адмиралтейская набережная, 10а'),
            trailing: Image.asset('assets/Icon-Edit.png'),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Выбрать')),
        ],
      ),
    );
  }
}
