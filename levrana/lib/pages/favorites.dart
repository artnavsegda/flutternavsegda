import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:levrana/pages/product.dart';

import '../gql.dart';
import '../components.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  var selectedRows = <int>{};

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getFavoritesProducts)),
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
                            value: selectedRows.length != 0 &&
                                selectedRows.containsAll(result
                                    .data!['getFavoritesProducts']
                                    .map((e) => e['iD'])
                                    .cast<int>()
                                    .toList()),
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue == true) {
                                  selectedRows.addAll(result
                                      .data!['getFavoritesProducts']
                                      .map((e) => e['iD'])
                                      .cast<int>()
                                      .toList());
                                } else {
                                  selectedRows.clear();
                                }
                              });
                            }),
                      ),
                      title: Text('Выбрано: ${selectedRows.length}'),
                      trailing: Wrap(spacing: 12, // space between two icons
                          children: <Widget>[
                            Mutation(
                                options: MutationOptions(
                                  document: gql(delFavoritesProducts),
                                  onCompleted: (resultData) {
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
                                      runMutation({
                                        'productIds': selectedRows.toList()
                                      });
                                    },
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Wrap(
                      spacing: 0,
                      runSpacing: 32,
                      children: result.data!['getFavoritesProducts']
                          .map(
                            (product) => FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: ProductCard(
                                        product: product,
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductPage(
                                                          id: product['iD'])));
                                          refetch!();
                                        }),
                                  ),
                                  Positioned(
                                    top: 10,
                                    child: LevranaBigCheckbox(
                                        value: selectedRows
                                            .contains(product['iD']),
                                        onChanged: (newValue) {
                                          if (newValue == true) {
                                            setState(() {
                                              selectedRows.add(product['iD']);
                                            });
                                          } else {
                                            setState(() {
                                              selectedRows
                                                  .remove(product['iD']);
                                            });
                                          }
                                        }),
                                  )
                                ],
                              ),
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
