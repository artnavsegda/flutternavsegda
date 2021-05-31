import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

@JsonSerializable()
class Product {
  Product({
    required this.ID,
    required this.Name,
    required this.PictureID,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  final int ID;
  final String Name;
  final int PictureID;
}

Future<List<Product>> getProducts(String token, String machineGUID) async {
  print("Request token: " + token);
  // Retrieve the locations of Google offices
  final response = await http.get(
      Uri.parse(
          'https://app.tseh85.com/service/api/vending/products?MachineGUID=' +
              machineGUID),
      headers: {
        'Token': token,
      });
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    return List<Product>.from(l.map((model) => Product.fromJson(model)));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(
            'https://app.tseh85.com/service/api/vending/products?MachineGUID=' +
                machineGUID));
  }
}
