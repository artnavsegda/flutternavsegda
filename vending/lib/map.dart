import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Machines> fetchMachines() async {}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class Machines {
  String gUID;
  String name;
  String address;
  double latitude;
  double longitude;
  String iBeaconUDID;
  String mACAddress;
  int serviceDate;

  Machines(
      {this.gUID,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.iBeaconUDID,
      this.mACAddress,
      this.serviceDate});

  Machines.fromJson(Map<String, dynamic> json) {
    gUID = json['GUID'];
    name = json['Name'];
    address = json['Address'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    iBeaconUDID = json['IBeaconUDID'];
    mACAddress = json['MACAddress'];
    serviceDate = json['ServiceDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GUID'] = this.gUID;
    data['Name'] = this.name;
    data['Address'] = this.address;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['IBeaconUDID'] = this.iBeaconUDID;
    data['MACAddress'] = this.mACAddress;
    data['ServiceDate'] = this.serviceDate;
    return data;
  }
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  Future<Machines> futureMachines;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    futureMachines = fetchMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        Container(
          height: 200.0,
          child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            SizedBox(
              width: 210,
              child: Card(
                child: Text('Hello World'),
              ),
            ),
            SizedBox(
              width: 210,
              child: Card(
                child: Text('Hello World'),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
