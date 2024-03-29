import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphql/levrana.dart';
//import '../../gql.dart';
import 'characteristicsElement.dart';

class ProductBottomSheet extends StatefulWidget {
  const ProductBottomSheet({Key? key, this.id = 0, required this.product})
      : super(key: key);

  final int id;
  final GraphProduct? product;

  @override
  _ProductBottomSheetState createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  GraphProductPrice? productPrice = GraphProductPrice.fromJson({'price': 0.0});
  Map<int, int> charMap = {};

  GraphProductPrice? getPrice(
      List<GraphProductPrice?>? priceList, int priceID) {
    Map<int, GraphProductPrice> priceMap = Map.fromIterable(priceList!,
        key: (e) => e.characteristicValueID, value: (e) => e);
    return priceMap[priceID];
  }

  void selectChar(int index, GraphCharacteristic? characteristic,
      List<GraphProductPrice?>? prices) {
    charMap[characteristic!.iD] = characteristic.values![index]!.iD;
    if (characteristic.isPrice) {
      GraphProductPrice? price =
          getPrice(prices, characteristic.values![index]!.iD);
      if (price != null)
        setState(() {
          productPrice = price;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Image.network(
                widget.product!.picture ?? "",
                width: 80,
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product!.name,
                    style: TextStyle(fontSize: 16.0)),
              )),
            ],
          ),
          Query(
              options: QueryOptions(
                document: GetProductQuery(
                        variables: GetProductArguments(productID: widget.id))
                    .document,
                variables: {
                  'productID': widget.id,
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                //print(result);
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading && result.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                GraphProductCard productInfo =
                    GraphProductCard.fromJson(result.data!['getProduct']);

                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  productInfo.characteristics!.forEach((element) {
                    if (element!.type != CharacteristicType.text) if (!charMap
                        .containsKey(element.iD))
                      selectChar(0, element, productInfo.prices);
                  });

                  if (productPrice!.price == 0.0 &&
                      productInfo.prices!.length == 1) {
                    setState(() {
                      productPrice = productInfo.prices![0];
                    });
                  }
                });

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: productInfo.characteristics!
                        .map((e) => CharacteristicsElement(
                              hideOne: true,
                              element: e,
                              onSelected: (index) =>
                                  selectChar(index, e, productInfo.prices),
                            ))
                        .toList()
                        .cast<Widget>());
              }),
          Mutation(
            options: MutationOptions(
              document: CartAddMutation(
                      variables: CartAddArguments(productID: widget.id))
                  .document,
              onCompleted: (resultData) {
                //print(resultData);
                Navigator.pop(context);
              },
            ),
            builder: (runMutation, result) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity,
                        48), // double.infinity is the width and 30 is the height
                  ),
                  onPressed: () {
                    List<int> charList =
                        charMap.entries.map((entry) => entry.value).toList();
                    //print(charList);
                    runMutation({
                      'productID': widget.id,
                      'characteristicValueIds': charList
                    });
                  },
                  child: Text(
                      "В КОРЗИНУ • ${productPrice!.price.toStringAsFixed(0)}₽",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w400)));
            },
          )
        ],
      ),
    );
  }
}
