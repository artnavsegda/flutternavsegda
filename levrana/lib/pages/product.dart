import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getProduct = r'''
query getProduct($productID: Int!) {
  getProduct(productID: $productID)
  {
    iD
    name
    stickerPictures
    comment
    characteristics {
      iD
      name
      type
      isPrice
      values {
        iD
        value
      }
    }
  }
}
''';

const String cartAdd = r'''
mutation cartAdd($productID: Int!) {
  cartAdd(cartItem: {productID: $productID, quantity: 1}) {
    result
  }
}
''';

class CharacteristicsElement extends StatelessWidget {
  const CharacteristicsElement({Key? key, this.element}) : super(key: key);

  final element;

  @override
  Widget build(BuildContext context) {
    switch (element['type']) {
      //case 'TEXT':
      //  return Text(element['name']);
      case 'VOLUME':
      case 'SIZE':
        return Row(
            children: element['values']
                .map((e) => ChoiceChip(
                      label: Text(e['value']),
                      selected: false,
                    ))
                .toList()
                .cast<Widget>());
      default:
        return Text(element['name']);
    }
  }
}

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
          print(result);
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
                  Column(
                      children: result.data!['getProduct']['characteristics']
                          .map((e) => CharacteristicsElement(element: e))
                          .toList()
                          .cast<Widget>()),
                  ExpansionTile(
                    leading: Icon(Icons.favorite),
                    trailing: Icon(Icons.favorite),
                    title: Text("Описание"),
                  ),
                  ExpansionTile(
                    title: Text("Состав"),
                  ),
                  ExpansionTile(
                    title: Text("Отзывы"),
                  ),
                  Mutation(
                    options: MutationOptions(
                      document: gql(cartAdd),
                      onCompleted: (resultData) {
                        print(resultData);
                      },
                    ),
                    builder: (runMutation, result) {
                      return ElevatedButton(
                          onPressed: () {
                            runMutation({
                              'productID': id,
                            });
                          },
                          child: Text("Купи"));
                    },
                  )
                ],
              ));
        });
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.product,
  }) : super(key: key);

  final product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  print(product['iD']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPage(id: product['iD'])),
                  );
                },
                child: Image.network(
                  product['picture'],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    print(product['iD']);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          color: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Image.network(
                                    product['picture'],
                                    width: 80,
                                  ),
                                  Flexible(child: Text(product['name'])),
                                ],
                              ),
                              Text('Modal BottomSheet'),
                              ElevatedButton(
                                child: const Text('Close BottomSheet'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/ic-24/icon-24-shopping.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              )
            ],
          ),
          Text(product['name']),
        ],
      ),
    );
  }
}
