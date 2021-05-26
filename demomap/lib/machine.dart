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

  Machine({required this.firstName, required this.lastName, this.dateOfBirth});
  factory Machine.fromJson(Map<String, dynamic> json) =>
      _$MachineFromJson(json);
  Map<String, dynamic> toJson() => _$MachineToJson(this);
}
