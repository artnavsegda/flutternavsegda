import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Machine>>(
        future: fetchMachines(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MachinesList(Machines: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MachinesList extends StatelessWidget {
  final List<Machine> Machines;

  MachinesList({Key? key, required this.Machines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: Machines.length,
      itemBuilder: (context, index) {
        return Text(Machines[index].name);
        //Image.network(Machines[index].thumbnailUrl);
      },
    );
  }
}
