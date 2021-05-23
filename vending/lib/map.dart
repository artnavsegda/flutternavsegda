import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Machine> parseMachines(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Machine>((json) => Machine.fromJson(json)).toList();
}

Future<List<Machine>> fetchMachines() async {
  final response = await http
      .get(Uri.parse('https://app.tseh85.com/service/api/vending/machines'));
  return parseMachines(response.body);
}

class Machine {
  String gUID;
  String name;
  String address;
  double latitude;
  double longitude;
  String iBeaconUDID;
  String mACAddress;
  String start;
  String finish;
  int serviceDate;

  Machine(
      {this.gUID,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.iBeaconUDID,
      this.mACAddress,
      this.start,
      this.finish,
      this.serviceDate});

  Machine.fromJson(Map<String, dynamic> json) {
    gUID = json['GUID'];
    name = json['Name'];
    address = json['Address'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    iBeaconUDID = json['IBeaconUDID'];
    mACAddress = json['MACAddress'];
    start = json['Start'];
    finish = json['Finish'];
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
    data['Start'] = this.start;
    data['Finish'] = this.finish;
    data['ServiceDate'] = this.serviceDate;
    return data;
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  Future<List<Machine>> futureMachines;

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
