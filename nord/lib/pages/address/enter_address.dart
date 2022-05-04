import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nord/gql.dart';

class EnterAddress extends StatefulWidget {
  const EnterAddress({Key? key, required this.addressToEdit}) : super(key: key);
  final GraphDeliveryAddress addressToEdit;

  @override
  State<EnterAddress> createState() => _EnterAddressState();
}

class _EnterAddressState extends State<EnterAddress> {
  late GraphDeliveryAddress addressToEdit;

  @override
  void initState() {
    super.initState();
    addressToEdit = widget.addressToEdit;
  }

  @override
  Widget build(BuildContext context) {
    late GoogleMapController _controller;
    return Scaffold(
      appBar: AppBar(title: Text('Адрес доставки')),
      body: Stack(
        children: [
          GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(addressToEdit.latitude, addressToEdit.longitude),
                zoom: 14.4746,
              ),
              onCameraIdle: () async {
                LatLngBounds visibleRegion =
                    await _controller.getVisibleRegion();
                LatLng centerLatLng = LatLng(
                  (visibleRegion.northeast.latitude +
                          visibleRegion.southwest.latitude) /
                      2,
                  (visibleRegion.northeast.longitude +
                          visibleRegion.southwest.longitude) /
                      2,
                );
                print(centerLatLng);
              },
              onMapCreated: (controller) {
                _controller = controller;
              }),
          Center(child: Icon(Icons.abc_outlined)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: addressToEdit.address,
              decoration: InputDecoration(
                  hintText: 'Поиск по адресу',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.0),
                    ),
                  ),
                  filled: true),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Доставить сюда')),
          ],
        ),
      ),
    );
  }
}
