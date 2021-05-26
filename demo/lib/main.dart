import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Machine>> fetchMachines(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://app.tseh85.com/service/api/vending/machines'));

  // Use the compute function to run parseMachines in a separate isolate.
  return compute(parseMachines, response.body);
}

// A function that converts a response body into a List<Machine>.
List<Machine> parseMachines(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Machine>((json) => Machine.fromJson(json)).toList();
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
        return Image.network(Machines[index].thumbnailUrl);
      },
    );
  }
}
