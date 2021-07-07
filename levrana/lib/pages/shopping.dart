import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:levrana/pages/product.dart';

const String getCart = r'''
query getCart {
  getCart {
    rowID
    productID
    productName
    quantity
    amount
    oldAmount
    modifiers
    comment
    picture
    message
    characteristics {
      type
      name
      value
    }
    modifiers
  }
}
''';

const String getFavoritesProducts = r'''
query getFavoritesProducts {
  getFavoritesProducts {
    iD
    name
    picture
  }
}
''';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: TabBar(labelColor: Colors.black, tabs: [
            Tab(text: "Корзина"),
            Tab(text: "Отложенные"),
          ]),
          body: TabBarView(
            children: [
              Query(
                  options: QueryOptions(document: gql(getCart)),
                  builder: (result, {refetch, fetchMore}) {
                    print(result);

                    if (result.hasException) {
                      return Center(
                        child: Text("Корзина недоступна"),
                      );
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(children: [
                      ListTile(
                          leading:
                              Checkbox(value: false, onChanged: (newValue) {}),
                          title: Text("Выбрано:4 "),
                          trailing: Wrap(spacing: 12, // space between two icons
                              children: <Widget>[
                                Icon(Icons.delete_outlined), // icon-1
                                Icon(Icons.favorite_outline), // icon-2
                              ])),
                      for (var item in result.data!['getCart'])
                        Container(
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Image.network(item['picture'], width: 80),
                                  Checkbox(
                                      value: false, onChanged: (newValue) {}),
                                ],
                              ),
                              Flexible(
                                child: Text(item['productName']),
                              ),
                            ],
                          ),
                        ),
                    ]);

                    return ListView.builder(
                        itemCount: result.data!['getCart'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                        result.data!['getCart'][index]
                                            ['picture'],
                                        width: 80),
                                    Checkbox(
                                        value: false, onChanged: (newValue) {}),
                                  ],
                                ),
                                Flexible(
                                  child: Text(result.data!['getCart'][index]
                                      ['productName']),
                                ),
                              ],
                            ),
                          );
                        });

                    return Center(
                        child: Image(
                      image: AssetImage('assets/Корзина пуста.png'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ));
                  }),
              Query(
                  options: QueryOptions(document: gql(getFavoritesProducts)),
                  builder: (result, {refetch, fetchMore}) {
                    print(result);

                    if (result.hasException) {
                      return Center(
                        child: Text("Корзина недоступна"),
                      );
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: result.data!['getFavoritesProducts'].length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                              product: result.data!['getFavoritesProducts']
                                  [index]);
                          return ListTile(
                              title: Text(result.data!['getFavoritesProducts']
                                  [index]['name']));
                        });

                    return Center(
                        child: Image(
                      image: AssetImage('assets/Корзина пуста.png'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
