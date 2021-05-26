import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<Machine>> fetchMachines(http.Client client) async {
  final response = await client.get(
      Uri.parse('https://app.tseh85.com/service/api/vending/machines'),
      headers: {
        'Token':
            'I9AHcsqu+0q4LsfEyDPrk7giWL1B4TEVTXu4XWTZyGzEgneula0iinS4C6L7bds2',
      });

  // Use the compute function to run parseMachines in a separate isolate.
  return compute(parseMachines, response.body);
}

// A function that converts a response body into a List<Machine>.
List<Machine> parseMachines(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Machine>((json) => Machine.fromJson(json)).toList();
}

class Machine {
  final String gUID;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String iBeaconUDID;
  final String mACAddress;
  final String start;
  final String finish;

  Machine(
      {required this.gUID,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.iBeaconUDID,
      required this.mACAddress,
      required this.start,
      required this.finish});

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      gUID: json['GUID'] as String,
      name: json['Name'] as String,
      address: json['Address'] as String,
      latitude: json['Latitude'] as double,
      longitude: json['Longitude'] as double,
      iBeaconUDID: json['IBeaconUDID'] as String,
      mACAddress: json['MACAddress'] as String,
      start: json['Start'] as String,
      finish: json['Finish'] as String,
    );
  }
}

/* class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Machine>>(
      future: fetchMachines(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? MachinesList(Machines: snapshot.data!)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
} */

class MachinesList extends StatelessWidget {
  final List<Machine> Machines;

  MachinesList({Key? key, required this.Machines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: Machines.length,
      itemBuilder: (context, index) {
        return Card(
          child: Text(Machines[index].name),
        );
        //Image.network(Machines[index].thumbnailUrl);
      },
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Machine>>(
      future: fetchMachines(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? Stack(children: [
                GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
                SizedBox(
                  height: 210,
                  child: MachinesList(Machines: snapshot.data!),
                ),
              ])
            : Center(child: CircularProgressIndicator());
      },
    );

/*     return Stack(
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
    ); */
  }
}
