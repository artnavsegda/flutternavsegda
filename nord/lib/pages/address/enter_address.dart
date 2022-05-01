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
    return Scaffold(
      appBar: AppBar(title: Text('Введите адрес')),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Сохранить')),
          TextFormField(initialValue: addressToEdit.description),
          TextFormField(initialValue: addressToEdit.address),
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(addressToEdit.latitude, addressToEdit.longitude),
                zoom: 14.4746,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
