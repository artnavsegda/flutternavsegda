import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

const String getProduct = r'''
query getProduct($productID: Int!) {
  getProduct(productID: $productID)
  {
    iD
    name
    pictures
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
    prices {
      price
      oldPrice
      characteristicValueID
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

const String setFavoritesProduct = r'''
mutation setFavoritesProduct($productID: Int!) {
  setFavoritesProduct(productId: $productID) {
    result
  }
}
''';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class CharacteristicsElement extends StatefulWidget {
  const CharacteristicsElement({Key? key, this.element, this.onSelected})
      : super(key: key);

  final element;
  final Function(int)? onSelected;

  @override
  _CharacteristicsElementState createState() => _CharacteristicsElementState();
}

class _CharacteristicsElementState extends State<CharacteristicsElement> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    switch (widget.element['type']) {
      //case 'TEXT':
      //  return Text(element['name']);
      case 'VOLUME':
      case 'SIZE':
        return Row(children: [
          for (int index = 0; index < widget.element['values'].length; index++)
            ChoiceChip(
                label: Text(widget.element['values'][index]['value']),
                selected: selected == index,
                onSelected: (bool newValue) {
                  widget.onSelected!(index);
                  setState(() {
                    selected = index;
                  });
                })
        ]);
      case 'COLOR':
        return Row(children: [
          for (int index = 0; index < widget.element['values'].length; index++)
            ChoiceChip(
                label: Text(widget.element['values'][index]['value']),
                selected: selected == index,
                disabledColor:
                    hexToColor(widget.element['values'][index]['value']),
                onSelected: (bool newValue) {
                  widget.onSelected!(index);
                  setState(() {
                    selected = index;
                  });
                })
        ]);
      default:
        return SizedBox.shrink();
        return Text(widget.element['name']);
    }
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, this.id = 0}) : super(key: key);

  final int id;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int picturePage = 0;

  dynamic _getPrice(priceList, priceID) {
    var priceMap = Map.fromIterable(priceList,
        key: (e) => e['characteristicValueID'], value: (e) => e);
    return priceMap[priceID];
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getProduct),
          variables: {
            'productID': widget.id,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          print(result);

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(result.data!['getProduct']['name'],
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: ListView(
                children: [
                  Container(
                    height: 292,
                    child: PageView.builder(
                        onPageChanged: (pageNum) => setState(() {
                              picturePage = pageNum;
                            }),
                        itemCount:
                            result.data!['getProduct']['pictures'].length,
                        itemBuilder: (context, index) {
                          return Image.network(
                              result.data!['getProduct']['pictures'][index]);
                        }),
                  ),
                  new DotsIndicator(
                    dotsCount: result.data!['getProduct']['pictures'].length,
                    position: picturePage.toDouble(),
                    decorator: DotsDecorator(
                      color: Colors.lightGreen, // Inactive color
                      activeColor: Colors.green,
                    ),
                  ),
                  Text(result.data!['getProduct']['name'],
                      style: GoogleFonts.montserrat(fontSize: 20)),
                  Text(result.data!['getProduct']['comment'] ?? "null"),
                  Column(
                      children: result.data!['getProduct']['characteristics']
                          .map((e) => CharacteristicsElement(
                                element: e,
                                onSelected: (index) {
                                  if (e['isPrice']) {
                                    var price = _getPrice(
                                        result.data!['getProduct']['prices'],
                                        e['values'][index]['iD']);
                                    print(price);
                                  }
                                },
                              ))
                          .toList()
                          .cast<Widget>()),
                  ExpandableTheme(
                    data: ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        iconPlacement: ExpandablePanelIconPlacement.left,
                        iconRotationAngle: pi / 2,
                        expandIcon: Icons.chevron_right,
                        collapseIcon: Icons.chevron_right),
                    child: Column(
                      children: [
                        ExpandablePanel(
                          header: Text("Характеристики"),
                          collapsed: SizedBox.shrink(),
                          expanded: Text("1234234234"),
                        ),
                        ExpandablePanel(
                          header: Text("Описание"),
                          collapsed: SizedBox.shrink(),
                          expanded: Text("1234234234"),
                        ),
                        ExpandablePanel(
                          header: Text("Состав"),
                          collapsed: SizedBox.shrink(),
                          expanded: Text("1234234234"),
                        ),
                        ExpandablePanel(
                          header: Text("Отзывы"),
                          collapsed: SizedBox.shrink(),
                          expanded: Text("1234234234"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
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
                                  'productID': widget.id,
                                });
                              },
                              child: Text("Купи"));
                        },
                      ),
                      Mutation(
                        options: MutationOptions(
                          document: gql(setFavoritesProduct),
                          onCompleted: (resultData) {
                            print(resultData);
                          },
                        ),
                        builder: (runMutation, result) {
                          return ElevatedButton(
                            onPressed: () {
                              runMutation({
                                'productID': widget.id,
                              });
                            },
                            child: Icon(
                              Icons.favorite_border_outlined,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                            ),
                          );
                        },
                      )
                    ],
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                    ),
                    width: 40,
                    height: 40,
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    print(product['iD']);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ProductBottomSheet(
                            product: product, id: product['iD']);
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

class ProductBottomSheet extends StatelessWidget {
  const ProductBottomSheet({Key? key, this.id = 0, this.product})
      : super(key: key);

  final int id;
  final product;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Query(
              options: QueryOptions(
                document: gql(getProduct),
                variables: {
                  'productID': id,
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                print(result);
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading && result.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: result.data!['getProduct']['characteristics']
                        .map((e) => CharacteristicsElement(
                              element: e,
                              onSelected: (index) {
                                print(index);
                              },
                            ))
                        .toList()
                        .cast<Widget>());
              }),
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
      ),
    );
  }
}
