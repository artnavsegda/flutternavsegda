import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import '../gql.dart';
import '../components.dart';

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
          //print(result);

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
                          style: TextStyle(
                            fontSize: 28.0,
                          )),
                      SizedBox(height: 8),
                      Text(
                          "Но это легко исправить. И вы даже знаете как это сделать ;)",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
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
                                //print(resultData);
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
                                //print(resultData);
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
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(6.0)),
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: item['picture'],
                                    width: 80),
                              ),
                              SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${item['amount']?.toStringAsFixed(0)}₽",
                                        style: TextStyle(
                                          fontSize: 32.0,
                                        )),
                                    Text(item['productName']),
                                    Column(
                                        children: item['characteristics']
                                            .map((e) => Text(e['value'],
                                                style: TextStyle(
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
                                  borderRadius: BorderRadius.circular(24)),
                              child: Mutation(
                                  options: MutationOptions(
                                    document: gql(
                                        cartEdit), // this is the mutation string you just created
                                    // you can update the cache based on results
                                    // or do something with the result.data on completion
                                    onCompleted: (dynamic resultData) {
                                      //print(resultData);
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
