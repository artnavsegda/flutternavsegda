import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../gql.dart';

class GraphProductAttribute {
  GraphProductAttribute({
    required this.iD,
    required this.name,
    required this.color,
  });
  int iD;
  String name;
  String color;

  GraphProductAttribute.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        color = json['color'];
}

class GraphProduct {
  GraphProduct({
    required this.iD,
    this.type,
    required this.familyID,
    required this.topCatalogID,
    required this.name,
    this.picture,
    required this.isFavorite,
    required this.favorites,
    required this.stickerPictures,
    required this.attributes,
  });
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

class GraphTopBlock {
  GraphTopBlock({
    required this.iD,
    required this.name,
    required this.products,
  });
  int iD;
  String name;
  List<GraphProduct> products;

  GraphTopBlock.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        products = List<GraphProduct>.from(
            json['products'].map((model) => GraphProduct.fromJson(model)));
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getTopBlocks),
      ),
      builder: (result, {fetchMore, refetch}) {
        print(result);
        if (result.isLoading || result.hasException) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GraphTopBlock> topBlocks = List<GraphTopBlock>.from(result
            .data!['getTopBlocks']
            .map((model) => GraphTopBlock.fromJson(model)));

        return ListView.builder(
            itemCount: topBlocks.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(topBlocks[index].name),
                  Column(
                      children: topBlocks[index]
                          .products
                          .map(
                            (e) => ListTile(
                              title: Text(e.name),
                              onTap: () {
                                context.goNamed('product', params: {
                                  'tab': 'main',
                                  'id': '${e.iD}',
                                });
                              },
                            ),
                          )
                          .toList()
                          .cast<Widget>()),
                ],
              );
            });
      },
    );
  }
}
