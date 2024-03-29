import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:math';

import '../../components/components.dart';
import '../../components/productCard.dart';
import '../../components/characteristicsElement.dart';
import '../../utils.dart';
import '../../graphql/levrana.dart';
//import '../../gql.dart';
import 'review.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int picturePage = 0;

  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GraphProductPrice? productPrice = GraphProductPrice.fromJson({'price': 0.0});
  Map<int, int> charMap = {};

  GraphProductPrice? getPrice(
      List<GraphProductPrice?>? priceList, int priceID) {
    Map<int, GraphProductPrice> priceMap = Map.fromIterable(priceList!,
        key: (e) => e.characteristicValueID, value: (e) => e);
    return priceMap[priceID];
  }

  void selectChar(int index, GraphCharacteristic? characteristic,
      List<GraphProductPrice?>? prices, List<GraphPicture?>? pictures) {
    for (var i = 0; i < pictures!.length; i++) {
      if (pictures[i]!.characteristicValueID ==
          characteristic!.values![index]!.iD) {
        _controller.jumpToPage(i);
        break;
      }
    }

    /*     pictures.asMap().forEach((pictureIndex, element) {
      if (element['characteristicValueID'] ==
          characteristic['values'][index]['iD']) {
        _controller.jumpToPage(pictureIndex);
      }
    }); */

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
    return Query(
        options: QueryOptions(
          document: GetProductQuery(
                  variables: GetProductArguments(productID: widget.id))
              .document,
          variables: {
            'productID': widget.id,
          },
          fetchPolicy: FetchPolicy.cacheFirst,
        ),
        builder: (result, {fetchMore, refetch}) {
          //print(result);

          if (result.hasException) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      result.exception.toString(),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Назад"))
                  ],
                ),
              ),
            );
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

/*           return Scaffold(
            body: Center(
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    result.data!['getProduct'].toString(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Назад"))
                ],
              ),
            ),
          ); */

          GraphProductCard productInfo =
              GraphProductCard.fromJson(result.data!['getProduct']);

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            productInfo.characteristics!.forEach((element) {
              if (element!.type != CharacteristicType.text) if (!charMap
                  .containsKey(element.iD))
                selectChar(
                    0, element, productInfo.prices, productInfo.pictures);
            });

            if (productPrice!.price == 0.0 && productInfo.prices!.length == 1) {
              setState(() {
                productPrice = productInfo.prices![0];
              });
            }
          });

          bool isShowChar = productInfo.characteristics!.indexWhere(
                  (element) => element!.type == CharacteristicType.text) !=
              -1;

          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(productInfo.name,
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Stack(children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();
                    await Future.delayed(Duration(seconds: 1));
                  },
                  child: ListView(
                    children: [
                      Container(
                        height: 340,
                        child: PageView.builder(
                            controller: _controller,
                            onPageChanged: (pageNum) => setState(() {
                                  picturePage = pageNum;
                                }),
                            itemCount: productInfo.pictures!.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      imageErrorBuilder: (context, exception,
                                              stackTrace) =>
                                          Center(
                                              child:
                                                  Icon(Icons.no_photography)),
                                      image:
                                          productInfo.pictures![index]!.full),
                                  if (productInfo.stickerPictures!.length >
                                      index)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Image.network(
                                          productInfo.stickerPictures![index] ??
                                              ""),
                                    )
                                ],
                              );
                            }),
                      ),
                      new DotsIndicator(
                        dotsCount: productInfo.pictures!.length,
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
                                productPrice!.price == 0.0
                                    ? SizedBox.shrink()
                                    : Text(
                                        productPrice!.price.toStringAsFixed(0) +
                                            "₽",
                                        style: TextStyle(fontSize: 32)),
                                SizedBox(width: 10),
                                productPrice!.oldPrice == null
                                    ? SizedBox.shrink()
                                    : CustomPaint(
                                        painter: RedLine(),
                                        child: Text(
                                            productPrice!.oldPrice!
                                                    .toStringAsFixed(0) +
                                                "₽",
                                            style: TextStyle(
                                                fontSize: 32,
                                                color: Colors.black45)),
                                      ),
                              ],
                            ),
                            Row(
                              children: productInfo.attributes!
                                  .map((element) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: ChoiceChip(
                                          visualDensity: VisualDensity.compact,
                                          labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          selectedColor:
                                              hexToColor(element!.color),
                                          selected: true,
                                          onSelected: (e) {},
                                          label: Text(element.name)),
                                    );
                                  })
                                  .toList()
                                  .cast<Widget>(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 8.0),
                              child: Text(productInfo.name,
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Text(productInfo.comment ?? "",
                                style: TextStyle(fontSize: 16.0)),
                            Column(
                                children: productInfo.characteristics!
                                    .map((e) => CharacteristicsElement(
                                          element: e,
                                          onSelected: (index) => selectChar(
                                              index,
                                              e,
                                              productInfo.prices,
                                              productInfo.pictures),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isShowChar)
                                    ExpandablePanel(
                                      header: Text("Характеристики",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      collapsed: SizedBox.shrink(),
                                      expanded: Column(
                                          children: productInfo.characteristics!
                                              .map((e) => TextCharacteristic(
                                                  element: e))
                                              .toList()
                                              .cast<Widget>()),
                                    ),
                                  ExpandablePanel(
                                    header: Text("Описание",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    collapsed: SizedBox.shrink(),
                                    expanded: MarkdownBody(
                                        data: productInfo.description ?? ""),
                                  ),
                                  ExpandablePanel(
                                    header: Text("Состав",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    collapsed: SizedBox.shrink(),
                                    expanded: Column(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: productInfo.compositions!
                                                .map((element) {
                                                  return Image.network(
                                                    element!.picture ?? "",
                                                    height: 100,
                                                    width: 100,
                                                  );
                                                })
                                                .toList()
                                                .cast<Widget>(),
                                          ),
                                        ),
                                        MarkdownBody(
                                            data:
                                                productInfo.composition ?? ""),
                                      ],
                                    ),
                                  ),
                                  ExpandablePanel(
                                    header: Text("Отзывы",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
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
                                            children: productInfo.reviews!
                                                .map((element) =>
                                                    Text(element!.text ?? ""))
                                                .toList()
                                                .cast<Widget>())
                                      ],
                                    ),
                                  ),
                                  if (productInfo.link!.length > 0)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 24),
                                        Text("С этим берут",
                                            style: TextStyle(fontSize: 32)),
                                        SizedBox(height: 12),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: productInfo.link!
                                                  .map((element) => SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.1,
                                                      child: ProductCard(
                                                          product: element)))
                                                  .toList()
                                                  .cast<Widget>()),
                                        ),
                                      ],
                                    ),
                                  if (productInfo.similar!.length > 0)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 48),
                                        Text("Похожие товары",
                                            style: TextStyle(fontSize: 32)),
                                        SizedBox(height: 12),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: productInfo.similar!
                                                  .map((element) => SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.1,
                                                      child: ProductCard(
                                                          product: element)))
                                                  .toList()
                                                  .cast<Widget>()),
                                        ),
                                      ],
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
                              document: CartAddMutation(
                                      variables: CartAddArguments(
                                          productID: widget.id))
                                  .document,
                              onCompleted: (resultData) {
                                //print(resultData);

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text('Добавлен в корзину'),
                                ));
                              },
                            ),
                            builder: (runMutation, result) {
                              return ElevatedButton(
                                  onPressed: () {
                                    List<int> charList = charMap.entries
                                        .map((entry) => entry.value)
                                        .toList();
                                    //print(charList);
                                    runMutation({
                                      'productID': widget.id,
                                      'characteristicValueIds': charList
                                    });
                                  },
                                  child: Text(
                                      "В КОРЗИНУ • ${productPrice!.price.toStringAsFixed(0)}₽",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      )));
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Mutation(
                          options: MutationOptions(
                            document: SetFavoritesProductMutation(
                                    variables: SetFavoritesProductArguments(
                                        productID: widget.id))
                                .document,
                            onCompleted: (resultData) {
                              //print(resultData);
                              refetch!();
                            },
                          ),
                          builder: (runMutation, mutationResult) {
                            return ElevatedButton.icon(
                              onPressed: () => runMutation({
                                'productID': widget.id,
                              }),
                              label: Text("${productInfo.favorites}"),
                              icon: productInfo.isFavorite
                                  ? Icon(Icons.favorite_outlined)
                                  : Icon(Icons.favorite_border_outlined),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(48, 48),
                                primary: productInfo.isFavorite
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            );
                          },
                        ),
                      ],
                    ))
              ]));
        });
  }
}
