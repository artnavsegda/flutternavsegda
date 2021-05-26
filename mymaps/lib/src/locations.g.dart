// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Machine _$MachineFromJson(Map<String, dynamic> json) {
  return Machine(
    GUID: json['GUID'] as String,
    Name: json['Name'] as String,
    Address: json['Address'] as String,
    Latitude: (json['Latitude'] as num).toDouble(),
    Longitude: (json['Longitude'] as num).toDouble(),
    IBeaconUDID: json['IBeaconUDID'] as String,
    MACAddress: json['MACAddress'] as String,
    Start: json['Start'] as String,
    Finish: json['Finish'] as String,
    ServiceDate: json['ServiceDate'] as int?,
  );
}

Map<String, dynamic> _$MachineToJson(Machine instance) => <String, dynamic>{
      'GUID': instance.GUID,
      'Name': instance.Name,
      'Address': instance.Address,
      'Latitude': instance.Latitude,
      'Longitude': instance.Longitude,
      'IBeaconUDID': instance.IBeaconUDID,
      'MACAddress': instance.MACAddress,
      'Start': instance.Start,
      'Finish': instance.Finish,
      'ServiceDate': instance.ServiceDate,
    };

LatLng _$LatLngFromJson(Map<String, dynamic> json) {
  return LatLng(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Region _$RegionFromJson(Map<String, dynamic> json) {
  return Region(
    coords: LatLng.fromJson(json['coords'] as Map<String, dynamic>),
    id: json['id'] as String,
    name: json['name'] as String,
    zoom: (json['zoom'] as num).toDouble(),
  );
}

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'coords': instance.coords,
      'id': instance.id,
      'name': instance.name,
      'zoom': instance.zoom,
    };

Office _$OfficeFromJson(Map<String, dynamic> json) {
  return Office(
    address: json['address'] as String,
    id: json['id'] as String,
    image: json['image'] as String,
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
    name: json['name'] as String,
    phone: json['phone'] as String,
    region: json['region'] as String,
  );
}

Map<String, dynamic> _$OfficeToJson(Office instance) => <String, dynamic>{
      'address': instance.address,
      'id': instance.id,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'phone': instance.phone,
      'region': instance.region,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) {
  return Locations(
    offices: (json['offices'] as List<dynamic>)
        .map((e) => Office.fromJson(e as Map<String, dynamic>))
        .toList(),
    regions: (json['regions'] as List<dynamic>)
        .map((e) => Region.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'offices': instance.offices,
      'regions': instance.regions,
    };
