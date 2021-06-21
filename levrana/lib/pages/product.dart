import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getProduct = r'''
query getProduct($productID: Int!) {
  getProduct(productID: $productID)
  {
    name
    stickerPictures
    comment
  }
}
''';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, this.id = 0}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getProduct),
          variables: {
            'productID': id,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(result.data!['getProduct']['name'],
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Column(
                children: [
                  ExpansionTile(
                    leading: Icon(Icons.favorite),
                    trailing: Icon(Icons.favorite),
                    title: Text("Характеристики"),
                  ),
                  ExpansionTile(
                    title: Text("Описание"),
                  ),
                  ExpansionTile(
                    title: Text("Состав"),
                  ),
                  ExpansionTile(
                    title: Text("Отзывы"),
                  ),
                ],
              )

/*             Center(
              child: Text("$id"),
            ), */
              );
        });
  }
}
