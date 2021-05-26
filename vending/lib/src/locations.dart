import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

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

Future<List<Machine>> getMachines() async {
  // Retrieve the locations of Google offices
  final response = await http.get(
      Uri.parse('https://app.tseh85.com/service/api/vending/machines'),
      headers: {
        'Token':
            'I9AHcsqu+0q4LsfEyDPrk7giWL1B4TEVTXu4XWTZyGzEgneula0iinS4C6L7bds2',
      });
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    return List<Machine>.from(l.map((model) => Machine.fromJson(model)));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse('https://app.tseh85.com/service/api/vending/machines'));
  }
}
