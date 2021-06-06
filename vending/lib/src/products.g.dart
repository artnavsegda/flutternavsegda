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

ServiceRow _$ServiceRowFromJson(Map<String, dynamic> json) {
  return ServiceRow(
    ProductID: json['ProductID'] as int,
    Quantity: json['Quantity'] as int,
  );
}

Map<String, dynamic> _$ServiceRowToJson(ServiceRow instance) =>
    <String, dynamic>{
      'ProductID': instance.ProductID,
      'Quantity': instance.Quantity,
    };
