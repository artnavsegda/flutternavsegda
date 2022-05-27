import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'create_address.dart';

class EnterAddress extends StatefulWidget {
  const EnterAddress({Key? key}) : super(key: key);

  @override
  State<EnterAddress> createState() => _EnterAddressState();
}

class _EnterAddressState extends State<EnterAddress> {
  GraphNewDeliveryAddress addressToEdit = GraphNewDeliveryAddress(
      address: '', description: '', latitude: 59.9311, longitude: 30.3609);

  @override
  void initState() async {
    super.initState();
    Position myPosition = await Geolocator.getCurrentPosition();
    setState(() {
      addressToEdit.latitude = myPosition.latitude;
      addressToEdit.latitude = myPosition.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    final YandexGeocoder geocoder =
        YandexGeocoder(apiKey: '82e091fb-f1a8-49dd-bbdf-2c48a409ece0');
    late GoogleMapController _mapController;
    TextEditingController _textController =
        TextEditingController(text: addressToEdit.address);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: Text('Адрес доставки'),
      ),
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
                    await _mapController.getVisibleRegion();
                LatLng centerLatLng = LatLng(
                  (visibleRegion.northeast.latitude +
                          visibleRegion.southwest.latitude) /
                      2,
                  (visibleRegion.northeast.longitude +
                          visibleRegion.southwest.longitude) /
                      2,
                );
                final GeocodeResponse geocodeFromPoint =
                    await geocoder.getGeocode(GeocodeRequest(
                  geocode: PointGeocode(
                      latitude: centerLatLng.latitude,
                      longitude: centerLatLng.longitude),
                  lang: Lang.ru,
                ));
                _textController.text =
                    geocodeFromPoint.firstAddress?.formatted ?? 'wtf';
              },
              onMapCreated: (controller) {
                _mapController = controller;
              }),
          Center(
              child: Image.asset(
            'assets/3.0x/Pin.png',
            scale: 1.5,
          )),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _textController,
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
                onPressed: () async {
                  LatLngBounds visibleRegion =
                      await _mapController.getVisibleRegion();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAddress(
                                  addressToCreate: GraphNewDeliveryAddress(
                                address: _textController.text,
                                description: '',
                                latitude: (visibleRegion.northeast.latitude +
                                        visibleRegion.southwest.latitude) /
                                    2,
                                longitude: (visibleRegion.northeast.longitude +
                                        visibleRegion.southwest.longitude) /
                                    2,
                              ))));
                },
                child: Text('Доставить сюда')),
          ],
        ),
      ),
    );
  }
}
