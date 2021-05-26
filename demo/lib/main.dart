import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

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

@JsonSerializable()
class Machine {
  Machine(
      {required this.GUID,
      required this.Name,
      required this.Address,
      required this.Latitude,
      required this.Longitude,
      required this.IBeaconUDID,
      required this.MACAddress,
      required this.Start,
      required this.Finish,
      this.ServiceDate});

  factory Machine.fromJson(Map<String, dynamic> json) =>
      _$MachineFromJson(json);
  Map<String, dynamic> toJson() => _$MachineToJson(this);

  final String GUID;
  final String Name;
  final String Address;
  final double Latitude;
  final double Longitude;
  final String IBeaconUDID;
  final String MACAddress;
  final String Start;
  final String Finish;
  final int? ServiceDate;
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
    return ListView.builder(
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
