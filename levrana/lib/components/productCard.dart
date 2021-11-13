import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utils.dart';
import '../gql.dart';
import '../pages/product/productBottomSheet.dart';

class GraphProductAttribute {
  GraphProductAttribute(
    this.iD,
    this.name,
    this.color,
  );
  int iD;
  String name;
  String color;

  GraphProductAttribute.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        color = json['color'];
}

class GraphProduct {
  GraphProduct(
    this.iD,
    this.familyID,
    this.topCatalogID,
    this.name,
    this.isFavorite,
    this.favorites,
    this.stickerPictures,
    this.attributes,
  );
  int iD;
  String? type;
  int familyID;
  int topCatalogID;
  String name;
  String? picture;
  bool isFavorite;
  int favorites;
  List<String> stickerPictures;
  List<GraphProductAttribute> attributes;

  GraphProduct.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        familyID = json['familyID'],
        topCatalogID = json['topCatalogID'],
        name = json['name'],
        picture = json['picture'],
        isFavorite = json['isFavorite'],
        favorites = json['favorites'],
        stickerPictures = List<String>.from(json['stickerPictures']),
        attributes = List<GraphProductAttribute>.from(json['attributes']
            .map((model) => GraphProductAttribute.fromJson(model)));
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product, this.onTap})
      : super(key: key);

  final GraphProduct product;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                color: Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(6.0),
              )),
              InkWell(
                onTap: onTap,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: FadeInImage.memoryNetwork(
                        imageErrorBuilder: (context, exception, stackTrace) =>
                            Center(child: Icon(Icons.no_photography)),
                        placeholder: kTransparentImage,
                        image: product.picture ?? "")),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                    ),
                    width: 40,
                    height: 40,
                  )),
              Mutation(
                  options: MutationOptions(
                    document: gql(cartAdd),
                    onCompleted: (resultData) {
                      //print(resultData);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Добавлен в корзину'),
                      ));
                    },
                  ),
                  builder: (runMutation, result) {
                    return Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          //print(product['type']);
                          if (product.type != 'SIMPLE')
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: const Radius.circular(16.0)),
                              ),
                              context: context,
                              builder: (context) {
                                return ProductBottomSheet(
                                    product: product, id: product.iD);
                              },
                            );
                          else
                            runMutation({'productID': product.iD});
                        },
                        child: Image.asset(
                          'assets/ic-24/icon-24-shopping.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
        Row(
          children: product.attributes
              .map((element) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      labelStyle:
                          TextStyle(fontSize: 16.0, color: Colors.white),
                      selectedColor: hexToColor(element.color),
                      selected: true,
                      onSelected: (e) {},
                      label: Text(element.name)),
                );
              })
              .toList()
              .cast<Widget>(),
        ),
        Text(product.name),
      ],
    );
  }
}
