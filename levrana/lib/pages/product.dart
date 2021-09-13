import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';

const String getProduct = r'''
query getProduct($productID: Int!) {
  getProduct(productID: $productID)
  {
    iD
    type
    familyID
    topCatalogID
    name
    articles {
      characteristicValueID
      characteristicValue2ID
      value
    }
    comment
    description
    application
    composition
    isFavorite
    favorites
    attributes {
      iD
      name
      color
    }
    awards {
      iD
      name
      picture
    }
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
    pictures
    stickerPictures
    compositions {
      description
      picture
    }
    link {
      iD
    }
    similar {
      iD
    }
    modifiers {
      caption
    }
    reviews {
      clientName
      self
      date
      text
      mark
    }
  }
}
''';

const String addReviewProduct = r'''
mutation addReviewProduct($productID: Int, $mark: Int, $text: String)
{
  addReviewProduct(productID: $productID, mark: $mark, text: $text) {
    result
    errorMessage
  }
}
''';

const String cartAdd = r'''
mutation cartAdd($productID: Int!, $characteristicValueIds: [Int]) {
  cartAdd(cartItem: {productID: $productID, quantity: 1, characteristicValueIds: $characteristicValueIds}) {
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

class RedLine extends CustomPainter {
  @override
  void paint(canvas, size) {
    canvas.drawLine(
        Offset(0, size.height),
        Offset(size.width, 0),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class TextCharacteristic extends StatelessWidget {
  const TextCharacteristic({Key? key, this.element}) : super(key: key);

  final element;

  @override
  Widget build(BuildContext context) {
    if (element['type'] == 'TEXT')
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(element['name'], style: TextStyle(color: Colors.grey)),
        Text(element['values']
            .map((element) => element['value'])
            .reduce((value, element) => value + ', ' + element))
      ]);
    else
      return Container();
  }
}

class CharacteristicsElement extends StatefulWidget {
  const CharacteristicsElement(
      {Key? key, this.element, this.onSelected, this.hideOne = false})
      : super(key: key);

  final element;
  final bool hideOne;
  final Function(int)? onSelected;

  @override
  _CharacteristicsElementState createState() => _CharacteristicsElementState();
}

class _CharacteristicsElementState extends State<CharacteristicsElement> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.element['values'].length == 1 && widget.hideOne)
      return SizedBox.shrink();

    switch (widget.element['type']) {
      case 'VOLUME':
      case 'SIZE':
        return Row(children: [
          for (int index = 0; index < widget.element['values'].length; index++)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ChoiceChip(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: selected == index ? Colors.white : Colors.black,
                  ),
                  selectedColor: Colors.green,
                  label: Text(widget.element['values'][index]['value']),
                  selected: selected == index,
                  onSelected: (bool newValue) {
                    widget.onSelected!(index);
                    setState(() {
                      selected = index;
                    });
                  }),
            )
        ]);
      case 'COLOR':
        return Row(children: [
          for (int index = 0; index < widget.element['values'].length; index++)
            GestureDetector(
              onTap: () {
                widget.onSelected!(index);
                setState(() {
                  selected = index;
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: ShapeDecoration(
                    color: hexToColor(widget.element['values'][index]['value']),
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                width: 3,
                                color: selected == index
                                    ? Colors.white
                                    : hexToColor(widget.element['values'][index]
                                        ['value']))) +
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                width: 2,
                                color: hexToColor(widget.element['values']
                                    [index]['value'])))),
                child: SizedBox(
                  height: 22,
                  width: 35,
                ),
              ),
            )
/*             ChoiceChip(
                label: SizedBox(
                  width: 20,
                ), //Text(widget.element['values'][index]['value']),
                selected: selected == index,
                backgroundColor:
                    hexToColor(widget.element['values'][index]['value']),
                selectedColor:
                    hexToColor(widget.element['values'][index]['value']),
                onSelected: (bool newValue) {
                  widget.onSelected!(index);
                  setState(() {
                    selected = index;
                  });
                }) */
        ]);
      default:
        return SizedBox.shrink();
        return Text(widget.element['name']);
    }
  }
}

dynamic getPrice(priceList, priceID) {
  var priceMap = Map.fromIterable(priceList,
      key: (e) => e['characteristicValueID'], value: (e) => e);
  return priceMap[priceID];
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final myController = TextEditingController();
  int rating = 5;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Написать отзыв", style: TextStyle(fontSize: 32.0)),
                    SizedBox(
                      height: 24,
                    ),
                    Text("Ваша оценка",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                    RatingBar(
                      itemSize: 27,
                      initialRating: rating / 2.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Image.asset('assets/star.png'),
                        half: Image.asset('assets/star_half.png'),
                        empty: Image.asset('assets/star_border.png'),
                      ),
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = (newRating * 2).round();
                        });
                        print(newRating);
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: 'Отзыв'),
                      controller: myController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Mutation(
                        options: MutationOptions(
                          document: gql(addReviewProduct),
                          onError: (error) {
                            print(error);
                          },
                          onCompleted: (dynamic resultData) async {
                            print(resultData);
                            Navigator.pop(context);
                          },
                        ),
                        builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                        ) {
                          return ElevatedButton(
                              onPressed: () {
                                runMutation({
                                  'productID': widget.id,
                                  'text': myController.text,
                                  'mark': rating
                                });
                              },
                              child: Text("ОТПРАВИТЬ"));
                        }),
                    SizedBox(width: 16),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("ОТМЕНА")),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int picturePage = 0;

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
    return Query(
        options: QueryOptions(
          document: gql(getProduct),
          variables: {
            'productID': widget.id,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          print(result);

          if (result.hasException) {
            return Scaffold(
              body: Center(
                child: Text(
                  result.exception.toString(),
                ),
              ),
            );
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            result.data!['getProduct']['characteristics'].forEach((element) {
              if (element['type'] != "TEXT") if (!charMap
                  .containsKey(element['iD']))
                selectChar(0, element, result.data!['getProduct']['prices']);
            });
            if (productPrice['price'] == null &&
                result.data!['getProduct']['prices'].length == 1) {
              setState(() {
                productPrice = result.data!['getProduct']['prices'][0];
              });
            }
          });

          bool isShowChar = result.data!['getProduct']['characteristics']
                  .indexWhere((element) => element['type'] == "TEXT") !=
              -1;

          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(result.data!['getProduct']['name'] ?? "WHAT",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Stack(children: [
                ListView(
                  children: [
                    Container(
                      height: 340,
                      child: PageView.builder(
                          onPageChanged: (pageNum) => setState(() {
                                picturePage = pageNum;
                              }),
                          itemCount:
                              result.data!['getProduct']['pictures'].length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(result.data!['getProduct']
                                    ['pictures'][index]),
                                if (result
                                        .data!['getProduct']['stickerPictures']
                                        .length >
                                    index)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Image.network(
                                        result.data!['getProduct']
                                            ['stickerPictures'][index]),
                                  )
                              ],
                            );
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              productPrice['price'] == null
                                  ? SizedBox.shrink()
                                  : Text(
                                      productPrice['price']
                                              ?.toStringAsFixed(0) +
                                          "₽",
                                      style:
                                          GoogleFonts.montserrat(fontSize: 32)),
                              SizedBox(width: 10),
                              productPrice['oldPrice'] == null
                                  ? SizedBox.shrink()
                                  : CustomPaint(
                                      painter: RedLine(),
                                      child: Text(
                                          productPrice['oldPrice']
                                                  ?.toStringAsFixed(0) +
                                              "₽",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 32,
                                              color: Colors.black45)),
                                    ),
                            ],
                          ),
                          Row(
                            children: result.data!['getProduct']['attributes']
                                .map((element) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: ChoiceChip(
                                        visualDensity: VisualDensity.compact,
                                        labelStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                        selectedColor:
                                            hexToColor(element['color']),
                                        selected: true,
                                        onSelected: (e) {},
                                        label: Text(element['name'])),
                                  );
                                })
                                .toList()
                                .cast<Widget>(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 8.0),
                            child: Text(result.data!['getProduct']['name'],
                                style: GoogleFonts.montserrat(fontSize: 20)),
                          ),
                          Text(result.data!['getProduct']['comment'] ?? "",
                              style: TextStyle(fontSize: 16.0)),
                          Column(
                              children:
                                  result.data!['getProduct']['characteristics']
                                      .map((e) => CharacteristicsElement(
                                            element: e,
                                            onSelected: (index) => selectChar(
                                                index,
                                                e,
                                                result.data!['getProduct']
                                                    ['prices']),
                                          ))
                                      .toList()
                                      .cast<Widget>()),
                          SizedBox(height: 16),
                          ExpandableTheme(
                            data: ExpandableThemeData(
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                iconPlacement:
                                    ExpandablePanelIconPlacement.left,
                                iconPadding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 7),
                                iconRotationAngle: pi / 2,
                                expandIcon: Icons.chevron_right,
                                collapseIcon: Icons.chevron_right),
                            child: Column(
                              children: [
                                if (isShowChar)
                                  ExpandablePanel(
                                    header: Text("Характеристики",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    collapsed: SizedBox.shrink(),
                                    expanded: Column(
                                        children: result.data!['getProduct']
                                                ['characteristics']
                                            .map((e) =>
                                                TextCharacteristic(element: e))
                                            .toList()
                                            .cast<Widget>()),
                                  ),
                                ExpandablePanel(
                                  header: Text("Описание",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  collapsed: SizedBox.shrink(),
                                  expanded: MarkdownBody(
                                      data: result.data!['getProduct']
                                              ['description'] ??
                                          ""),
                                ),
                                ExpandablePanel(
                                  header: Text("Состав",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  collapsed: SizedBox.shrink(),
                                  expanded: Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: result.data!['getProduct']
                                                  ['compositions']
                                              .map((element) {
                                                return Image.network(
                                                  element['picture'],
                                                  height: 100,
                                                  width: 100,
                                                );
                                              })
                                              .toList()
                                              .cast<Widget>(),
                                        ),
                                      ),
                                      Text(result.data!['getProduct']
                                              ['composition'] ??
                                          ""),
                                    ],
                                  ),
                                ),
                                ExpandablePanel(
                                  header: Text("Отзывы",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  collapsed: SizedBox.shrink(),
                                  expanded: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      OutlinedButton(
                                          child: Text("НАПИСАТЬ ОТЗЫВ"),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: const Radius
                                                            .circular(16.0)),
                                              ),
                                              builder: (context) {
                                                return ReviewPage(
                                                    id: widget.id);
                                              },
                                            );
                                          }),
                                      Column(
                                          children: result.data!['getProduct']
                                                  ['reviews']
                                              .map((element) =>
                                                  Text(element['text']))
                                              .toList()
                                              .cast<Widget>())
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: 60 +
                                        MediaQuery.of(context).padding.bottom)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: Mutation(
                            options: MutationOptions(
                              document: gql(cartAdd),
                              onCompleted: (resultData) {
                                print(resultData);
                              },
                            ),
                            builder: (runMutation, result) {
                              return ElevatedButton(
                                  onPressed: () {
                                    List<int> charList = charMap.entries
                                        .map((entry) => entry.value)
                                        .toList();
                                    print(charList);
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
                          ),
                        ),
                        Mutation(
                          options: MutationOptions(
                            document: gql(setFavoritesProduct),
                            onCompleted: (resultData) {
                              print(resultData);
                              refetch!();
                            },
                          ),
                          builder: (runMutation, mutationResult) {
                            return ElevatedButton(
                              onPressed: () {
                                runMutation({
                                  'productID': widget.id,
                                });
                              },
                              child: result.data!['getProduct']['isFavorite']
                                  ? Icon(Icons.favorite_outlined,
                                      color: Colors.red)
                                  : Icon(Icons.favorite_border_outlined),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(48, 48),
                                shape: CircleBorder(),
                              ),
                            );
                          },
                        )
                      ],
                    ))
              ]));
        });
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, this.product, this.onTap}) : super(key: key);

  final product;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x10000000),
                ),
                child: Image.network(
                  product['picture'],
                ),
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
            Mutation(
                options: MutationOptions(
                  document: gql(cartAdd),
                  onCompleted: (resultData) {
                    print(resultData);
                  },
                ),
                builder: (runMutation, result) {
                  return Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        print(product['type']);
                        if (product['type'] != 'SIMPLE')
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: const Radius.circular(16.0)),
                            ),
                            context: context,
                            builder: (context) {
                              return ProductBottomSheet(
                                  product: product, id: product['iD']);
                            },
                          );
                        else
                          runMutation({'productID': product['iD']});
                      },
                      child: Image.asset(
                        'assets/ic-24/icon-24-shopping.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                })
          ],
        ),
        Text(product['name']),
      ],
    );
  }
}

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
                print(result);
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
                print(resultData);
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
                    print(charList);
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
