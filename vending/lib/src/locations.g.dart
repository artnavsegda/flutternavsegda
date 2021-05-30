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
    Start: json['Start'] as String?,
    Finish: json['Finish'] as String?,
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
