// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    ID: json['ID'] as int,
    Name: json['Name'] as String,
    PictureID: json['PictureID'] as int,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'ID': instance.ID,
      'Name': instance.Name,
      'PictureID': instance.PictureID,
    };
