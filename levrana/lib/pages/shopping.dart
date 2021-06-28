import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getCart = r'''
query getCart {
  getCart {
    productID
    productName
  }
}
''';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Query(
            options: QueryOptions(document: gql(getCart)),
            builder: (result, {refetch, fetchMore}) {
              print(result);
              return Center(
                  child: Image(
                image: AssetImage('assets/Корзина пуста.png'),
                width: double.infinity,
                fit: BoxFit.cover,
              ));
            }));
  }
}
