import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:levrana/pages/product.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components.dart';

const String cartEdit = r'''
mutation cartEdit($rowID: Int, $quantity: Int) {
  cartEdit(rowID: $rowID, quantity: $quantity) {
    result
    errorMessage
  }
}
''';

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

          if (result.data!['getCart'].length == 0) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/BasketEmpty.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Корзина пуста",
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                          )),
                      SizedBox(height: 8),
                      Text(
                          "Но это легко исправить. И вы даже знаете как это сделать ;)",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                )
              ],
            ));
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
                    child: LevranaCheckbox(
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.5),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(item['picture'], width: 80),
                              SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${item['amount']?.toStringAsFixed(0)}₽",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 32)),
                                    Text(item['productName']),
                                    Column(
                                        children: item['characteristics']
                                            .map((e) => Text(e['value'],
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16,
                                                    color: Colors.black45)))
                                            .toList()
                                            .cast<Widget>())
                                  ],
                                ),
                              )
                              /* Flexible(
                                          child: Text(item['productName']),
                                        ), */
                            ],
                          ),
                          SizedBox(height: 9),
                          Container(
                              width: 168,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: Mutation(
                                  options: MutationOptions(
                                    document: gql(
                                        cartEdit), // this is the mutation string you just created
                                    // you can update the cache based on results
                                    // or do something with the result.data on completion
                                    onCompleted: (dynamic resultData) {
                                      print(resultData);
                                      refetch!();
                                    },
                                  ),
                                  builder: (runMutation, result) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            onPressed: () => runMutation({
                                                  'rowID': item['rowID'],
                                                  'quantity':
                                                      item['quantity'] - 1
                                                }),
                                            child: Text('-')),
                                        Text(item['quantity'].toString()),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            onPressed: () => runMutation({
                                                  'rowID': item['rowID'],
                                                  'quantity':
                                                      item['quantity'] + 1
                                                }),
                                            child: Text('+'))
                                      ],
                                    );
                                  }))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 37,
                    left: 9,
                    child: SizedBox(
                      height: 32.0,
                      width: 32.0,
                      child: LevranaBigCheckbox(
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
                          }),
                    ),
                  )
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      tileColor: Colors.white,
                      leading: SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: LevranaCheckbox(
                            value: false, onChanged: (newValue) {}),
                      ),
                      title: Text('Выбрано: 0'),
                      trailing: Wrap(spacing: 12, // space between two icons
                          children: <Widget>[
                            Mutation(
                                options: MutationOptions(
                                  document: gql(cartDelete),
                                  onCompleted: (resultData) {},
                                ),
                                builder: (runMutation, result) {
                                  return IconButton(
                                    constraints: BoxConstraints(maxWidth: 36),
                                    icon: Icon(Icons.delete_outlined),
                                    onPressed: () {},
                                  );
                                }),
                          ])),
                ),
                Container(
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0))),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  padding: EdgeInsets.all(16.0),
                  child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: result.data!['getFavoritesProducts']
                          .map(
                            (product) => FractionallySizedBox(
                              widthFactor: 0.45,
                              child: ProductCard(
                                  product: product,
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductPage(
                                                id: product['iD'])));
                                    refetch!();
                                  }),
                            ),
                          )
                          .toList()
                          .cast<Widget>()),
                )
              ],
            ),
          );

          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: result.data!['getFavoritesProducts'].length,
              itemBuilder: (context, index) {
                var product = result.data!['getFavoritesProducts'][index];
                return ProductCard(
                    product: product,
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductPage(id: product['iD'])));
                      refetch!();
                    });
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
                  unselectedLabelStyle: TextStyle(fontSize: 16.0),
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 16.0),
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
