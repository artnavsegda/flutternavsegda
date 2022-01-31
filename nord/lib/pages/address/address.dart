import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
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
          SizedBox(height: 28),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 16),
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        padding: EdgeInsets.only(right: 16)),
                    onPressed: () {},
                    label: const Text('Доставка'),
                    icon: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                              'assets/Illustration-Colored-Delivery.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child:
                              Image.asset('assets/Icon-Checkbox-Checked.png'),
                        ),
                      ],
                    )),
                SizedBox(width: 8),
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.only(right: 16)),
                    onPressed: () {},
                    label: const Text('Самовывоз'),
                    icon: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                              'assets/Illustration-Colored-Cafe.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child:
                              Image.asset('assets/Icon-Checkbox-Unchecked.png'),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          ListTile(
            title: const Text('Адмиралтейская набережная, 10а'),
            trailing: Image.asset('assets/Icon-Edit.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                ElevatedButton(onPressed: () {}, child: const Text('Выбрать')),
          ),
        ],
      ),
    );
  }
}
