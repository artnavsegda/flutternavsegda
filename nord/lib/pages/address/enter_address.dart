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
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(addressToEdit.latitude, addressToEdit.longitude),
          zoom: 14.4746,
        ),
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
