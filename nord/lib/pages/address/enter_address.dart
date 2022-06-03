import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart' as Geocoder;
import 'package:latlong2/latlong.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Geocoder.YandexGeocoder geocoder =
        Geocoder.YandexGeocoder(apiKey: '82e091fb-f1a8-49dd-bbdf-2c48a409ece0');
    late YandexMapController _mapController;
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
          YandexMap(
            onMapCreated: (controller) {
              _mapController = controller;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: Point(latitude: 59.9311, longitude: 30.3609),
                        zoom: 13)));
              });
            },
            onCameraPositionChanged: (cameraPosition, reason, finished) async {
              if (finished) {
                VisibleRegion visibleRegion =
                    await _mapController.getVisibleRegion();
                LatLng centerLatLng = LatLng(
                  (visibleRegion.topRight.latitude +
                          visibleRegion.bottomLeft.latitude) /
                      2,
                  (visibleRegion.topRight.longitude +
                          visibleRegion.bottomLeft.longitude) /
                      2,
                );
                final Geocoder.GeocodeResponse geocodeFromPoint =
                    await geocoder.getGeocode(Geocoder.GeocodeRequest(
                  geocode: Geocoder.PointGeocode(
                      latitude: centerLatLng.latitude,
                      longitude: centerLatLng.longitude),
                  lang: Geocoder.Lang.ru,
                ));
                _textController.text =
                    geocodeFromPoint.firstAddress?.formatted ?? 'wtf';
              }
            },
          ),
          Center(
              child: Image.asset(
            'assets/3.0x/Pin.png',
            scale: 1.5,
          )),
        ],
      ),
      bottomNavigationBar: Padding(
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
                  VisibleRegion visibleRegion =
                      await _mapController.getVisibleRegion();
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAddress(
                                  addressToCreate: GraphNewDeliveryAddress(
                                address: _textController.text,
                                description: '',
                                latitude: (visibleRegion.topRight.latitude +
                                        visibleRegion.bottomLeft.latitude) /
                                    2,
                                longitude: (visibleRegion.topRight.longitude +
                                        visibleRegion.bottomLeft.longitude) /
                                    2,
                              ))));
                  Navigator.pop(context);
                },
                child: Text('Доставить сюда')),
          ],
        ),
      ),
    );
  }
}
