import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../gql.dart';
import '../../components/components.dart';
import '../../utils.dart';

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
            return const Center(
              child: Text("Корзина недоступна"),
            );
          }

          if (result.isLoading) {
            return RefreshIndicator(
              onRefresh: () async {
                await refetch!();
                //await Future.delayed(Duration(seconds: 5));
              },
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          List<GraphCartRow> cart = List<GraphCartRow>.from(result
              .data!['getCart']
              .map((model) => GraphCartRow.fromJson(model)));

          if (cart.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/BasketEmpty.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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

          return RefreshIndicator(
            onRefresh: () async {
              await refetch!();
              //await Future.delayed(Duration(seconds: 5));
            },
            child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        tileColor: Colors.white,
                        leading: SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: LevranaCheckbox(
                              value: selectedRows.isNotEmpty &&
                                  selectedRows.containsAll(
                                      cart.map((e) => e.rowID).toList()),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue == true) {
                                    selectedRows.addAll(
                                        cart.map((e) => e.rowID).toList());
                                    selectedFavs.addAll(
                                        cart.map((e) => e.productID).toList());
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
                                      constraints:
                                          const BoxConstraints(maxWidth: 36),
                                      icon: const Icon(Icons.delete_outlined),
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
                                      constraints:
                                          const BoxConstraints(maxWidth: 36),
                                      icon: const Icon(Icons.favorite_outline),
                                      onPressed: () {
                                        runMutation({
                                          'productIds': selectedFavs.toList()
                                        });
                                      },
                                    );
                                  }),
                            ])),
                  ),
                  for (var item in cart)
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 0.5),
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
                                          color: const Color(0xFFF6F6F6),
                                          borderRadius:
                                              BorderRadius.circular(6.0)),
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: item.picture ?? "",
                                          width: 80),
                                    ),
                                    const SizedBox(width: 9),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${item.amount.toStringAsFixed(0)}₽",
                                              style: const TextStyle(
                                                fontSize: 32.0,
                                              )),
                                          Text(item.productName),
                                          Row(
                                              children: item.characteristics
                                                  .map((e) =>
                                                      MiniCharacteristic(
                                                          element: e))
                                                  .toList()
                                                  .cast<Widget>())
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 9),
                                Container(
                                    width: 168,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius:
                                            BorderRadius.circular(24)),
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
                                                        'rowID': item.rowID,
                                                        'quantity':
                                                            item.quantity - 1
                                                      }),
                                                  child: const Text('-')),
                                              Text(item.quantity.toString()),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.black,
                                                  ),
                                                  onPressed: () => runMutation({
                                                        'rowID': item.rowID,
                                                        'quantity':
                                                            item.quantity + 1
                                                      }),
                                                  child: const Text('+'))
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
                                value: selectedRows.contains(item.rowID),
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      selectedRows.add(item.rowID);
                                      selectedFavs.add(item.productID);
                                    });
                                  } else {
                                    setState(() {
                                      selectedRows.remove(item.rowID);
                                      selectedFavs.remove(item.productID);
                                    });
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                ]),
          );
        });
  }
}

class MiniCharacteristic extends StatelessWidget {
  const MiniCharacteristic({
    required this.element,
    Key? key,
  }) : super(key: key);

  final GraphCartCharacteristic element;

  @override
  Widget build(BuildContext context) {
    if (element.type == 'COLOR') {
      return Text('⬤ ',
          style: TextStyle(fontSize: 7.0, color: hexToColor(element.value)));
    } else {
      return Text(element.value,
          style: const TextStyle(fontSize: 16, color: Colors.black45));
    }
  }
}
