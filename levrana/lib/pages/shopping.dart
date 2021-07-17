import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:levrana/pages/product.dart';
import 'package:google_fonts/google_fonts.dart';

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

const String cartDelete = r'''
mutation cartDelete($rowIDs: [Int]) {
  cartDelete(rowIDs: $rowIDs) {
    result
    errorMessage
  }
}
''';

const String setFavoritesProducts = r'''
mutation setFavoritesProducts($productIds: [Int]) {
  setFavoritesProducts(productIds: $productIds) {
    result
    errorMessage
  }
}
''';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  var selectedRows = <int>{};
  var selectedFavs = <int>{};

  @override
  Widget build(BuildContext context) {
    return Query(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  tileColor: Colors.white,
                  leading: SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: Checkbox(
                        value: selectedRows.length != 0 &&
                            selectedRows.containsAll(result.data!['getCart']
                                .map((e) => e['rowID'])
                                .cast<int>()
                                .toList()),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == true) {
                              selectedRows.addAll(result.data!['getCart']
                                  .map((e) => e['rowID'])
                                  .cast<int>()
                                  .toList());
                              selectedFavs.addAll(result.data!['getCart']
                                  .map((e) => e['productID'])
                                  .cast<int>()
                                  .toList());
                            } else {
                              selectedRows.clear();
                              selectedFavs.clear();
                            }
                          });
                        }),
                  ),
                  title: Text('Выбрано: ${selectedRows.length}'),
                  trailing: Wrap(spacing: 12, // space between two icons
                      children: <Widget>[
                        Mutation(
                            options: MutationOptions(
                              document: gql(cartDelete),
                              onCompleted: (resultData) {
                                print(resultData);
                                refetch!();
                                setState(() {
                                  selectedRows.clear();
                                });
                              },
                            ),
                            builder: (runMutation, result) {
                              return IconButton(
                                constraints: BoxConstraints(maxWidth: 36),
                                icon: Icon(Icons.delete_outlined),
                                onPressed: () {
                                  runMutation(
                                      {'rowIDs': selectedRows.toList()});
                                },
                              );
                            }),
                        Mutation(
                            options: MutationOptions(
                              document: gql(setFavoritesProducts),
                              onCompleted: (resultData) {
                                print(resultData);
                                refetch!();
                                setState(() {
                                  selectedFavs.clear();
                                });
                              },
                            ),
                            builder: (runMutation, result) {
                              return IconButton(
                                constraints: BoxConstraints(maxWidth: 36),
                                icon: Icon(Icons.favorite_outline),
                                onPressed: () {
                                  runMutation(
                                      {'productIds': selectedFavs.toList()});
                                },
                              );
                            }),
                      ])),
            ),
            for (var item in result.data!['getCart'])
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(item['picture'], width: 80),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['amount'].toString()),
                                    Text(item['productName']),
                                  ],
                                ),
                              )
                              /* Flexible(
                                          child: Text(item['productName']),
                                        ), */
                            ],
                          ),
                          Container(
                              color: Colors.black12,
                              child: Text(item['quantity'].toString()))
                        ],
                      ),
                    ),
                  ),
                  Checkbox(
                      value: selectedRows.contains(item['rowID']),
                      onChanged: (newValue) {
                        if (newValue == true) {
                          setState(() {
                            selectedRows.add(item['rowID']);
                            selectedFavs.add(item['productID']);
                          });
                        } else {
                          setState(() {
                            selectedRows.remove(item['rowID']);
                            selectedFavs.remove(item['productID']);
                          });
                        }
                      })
                ],
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
                              result.data!['getCart'][index]['picture'],
                              width: 80),
                          Checkbox(value: false, onChanged: (newValue) {}),
                        ],
                      ),
                      Flexible(
                        child:
                            Text(result.data!['getCart'][index]['productName']),
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
        });
  }
}

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: result.data!['getFavoritesProducts'].length,
              itemBuilder: (context, index) {
                return ProductCard(
                    product: result.data!['getFavoritesProducts'][index]);
                return ListTile(
                    title: Text(
                        result.data!['getFavoritesProducts'][index]['name']));
              });

          return Center(
              child: Image(
            image: AssetImage('assets/Корзина пуста.png'),
            width: double.infinity,
            fit: BoxFit.cover,
          ));
        });
  }
}

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabBar(
                  unselectedLabelColor: Colors.black38,
                  unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 16),
                  labelColor: Colors.black,
                  labelStyle: GoogleFonts.montserrat(fontSize: 16),
                  tabs: [
                    Tab(text: "Корзина"),
                    Tab(text: "Отложенные"),
                  ]),
            ),
          ),
          body: TabBarView(
            children: [ShoppingCartPage(), FavouritesPage()],
          ),
        ),
      ),
    );
  }
}
