import 'package:json_annotation/json_annotation.dart';

part 'machine.g.dart';

@JsonSerializable()
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
  final Int? serviceDate;

  Machine(
      {required this.gUID,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.iBeaconUDID,
      required this.mACAddress,
      required this.start,
      required this.finish,
      this.serviceDate});
  factory Machine.fromJson(Map<String, dynamic> json) =>
      _$MachineFromJson(json);
  Map<String, dynamic> toJson() => _$MachineToJson(this);
}
