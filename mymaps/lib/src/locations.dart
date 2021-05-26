/*
 * Copyright 2019 Google LLC
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

@JsonSerializable()
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Region {
  Region({
    required this.coords,
    required this.id,
    required this.name,
    required this.zoom,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);

  final LatLng coords;
  final String id;
  final String name;
  final double zoom;
}

@JsonSerializable()
class Office {
  Office({
    required this.address,
    required this.id,
    required this.image,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.region,
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);

  final String address;
  final String id;
  final String image;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String region;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.offices,
    required this.regions,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Office> offices;
  final List<Region> regions;
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
        uri: Uri.parse(googleLocationsURL));
  }
}

Future<Locations> getGoogleOffices() async {
  const googleLocationsURL = 'https://about.google/static/data/locations.json';

  // Retrieve the locations of Google offices
  final response = await http.get(Uri.parse(googleLocationsURL));
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(googleLocationsURL));
  }
}
