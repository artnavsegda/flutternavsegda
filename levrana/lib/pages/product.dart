import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getProduct = """
query getProduct {
  getProduct(productID: 2)
  {
    name
    stickerPictures
    comment
  }
}
""";

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, this.id = 0}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getProduct)),
        builder: (result, {fetchMore, refetch}) {
          return Scaffold(
            appBar: AppBar(
              title: Text(result.data!['getProduct']['name']),
            ),
            body: Center(
              child: Text("$id"),
            ),
          );
        });
  }
}
