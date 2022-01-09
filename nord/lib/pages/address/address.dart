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
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
      ),
      bottomNavigationBar: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                  onPressed: () {},
                  label: const Text('Доставка'),
                  icon:
                      Image.asset('assets/Illustration-Colored-Delivery.png')),
              OutlinedButton.icon(
                  onPressed: () {},
                  label: const Text('Самовывоз'),
                  icon: Image.asset('assets/Illustration-Colored-Cafe.png'))
            ],
          ),
          ListTile(
            title: const Text('Адмиралтейская набережная, 10а'),
            trailing: Image.asset('assets/Icon-Edit.png'),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Выбрать')),
        ],
      ),
    );
  }
}
