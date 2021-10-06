import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../gql.dart';
import '../components.dart';

class ProductBottomSheet extends StatefulWidget {
  const ProductBottomSheet({Key? key, this.id = 0, this.product})
      : super(key: key);

  final int id;
  final product;

  @override
  _ProductBottomSheetState createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  Map<String, dynamic> productPrice = {'price': null, 'oldPrice': null};
  Map<int, int> charMap = {};

  void selectChar(index, characteristic, prices) {
    charMap[characteristic['iD']] = characteristic['values'][index]['iD'];
    if (characteristic['isPrice']) {
      var price = getPrice(prices, characteristic['values'][index]['iD']);
      if (price != null)
        setState(() {
          productPrice = Map<String, dynamic>.from(price);
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
                widget.product['picture'],
                width: 80,
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product['name'],
                    style: TextStyle(fontSize: 16.0)),
              )),
            ],
          ),
          Query(
              options: QueryOptions(
                document: gql(getProduct),
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

                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  result.data!['getProduct']['characteristics']
                      .forEach((element) {
                    if (element['type'] != "TEXT") if (!charMap
                        .containsKey(element['iD']))
                      selectChar(
                          0, element, result.data!['getProduct']['prices']);
                  });

                  if (productPrice['price'] == null &&
                      result.data!['getProduct']['prices'].length == 1) {
                    setState(() {
                      productPrice = result.data!['getProduct']['prices'][0];
                    });
                  }
                });

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: result.data!['getProduct']['characteristics']
                        .map((e) => CharacteristicsElement(
                              hideOne: true,
                              element: e,
                              onSelected: (index) => selectChar(index, e,
                                  result.data!['getProduct']['prices']),
                            ))
                        .toList()
                        .cast<Widget>());
              }),
          Mutation(
            options: MutationOptions(
              document: gql(cartAdd),
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
                      "В КОРЗИНУ • ${productPrice['price']?.toStringAsFixed(0)}₽",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )));
            },
          )
        ],
      ),
    );
  }
}
