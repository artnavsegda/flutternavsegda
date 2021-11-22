import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

import '../../components/components.dart';
import '../../components/product_card.dart';
import '../../components/characteristics_element.dart';
import '../../utils.dart';
import '../../gql.dart';
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

  GraphProductPrice productPrice = GraphProductPrice(price: 0.0);
  Map<int, int> charMap = {};

  GraphProductPrice? getPrice(List<GraphProductPrice> priceList, int priceID) {
    Map<int, GraphProductPrice> priceMap = {
      for (var e in priceList) e.characteristicValueID ?? 0: e
    };
    return priceMap[priceID];
  }

  void selectChar(int index, GraphCharacteristics characteristic,
      List<GraphProductPrice> prices, List<GraphPicture> pictures) {
    for (var i = 0; i < pictures.length; i++) {
      if (pictures[i].characteristicValueID ==
          characteristic.values[index].iD) {
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

    charMap[characteristic.iD] = characteristic.values[index].iD;
    if (characteristic.isPrice) {
      GraphProductPrice? price =
          getPrice(prices, characteristic.values[index].iD);
      if (price != null) {
        setState(() {
          productPrice = price;
        });
      }
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
                        child: const Text("Назад"))
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
            for (var element in productInfo.characteristics) {
              if (element.type != "TEXT") {
                if (!charMap.containsKey(element.iD)) {
                  selectChar(
                      0, element, productInfo.prices, productInfo.pictures);
                }
              }
            }

            if (productPrice.price == 0.0 && productInfo.prices.length == 1) {
              setState(() {
                productPrice = productInfo.prices[0];
              });
            }
          });

          bool isShowChar = productInfo.characteristics
                  .indexWhere((element) => element.type == "TEXT") !=
              -1;

          return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(productInfo.name,
                    style: const TextStyle(color: Colors.black)),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Stack(children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 340,
                        child: PageView.builder(
                            controller: _controller,
                            onPageChanged: (pageNum) => setState(() {
                                  picturePage = pageNum;
                                }),
                            itemCount: productInfo.pictures.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  CachedNetworkImage(
                                      imageUrl:
                                          productInfo.pictures[index].full,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.no_photography)),
                                  if (productInfo.stickerPictures.length >
                                      index)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Image.network(
                                          productInfo.stickerPictures[index]),
                                    )
                                ],
                              );
                            }),
                      ),
                      DotsIndicator(
                        dotsCount: productInfo.pictures.length,
                        position: picturePage.toDouble(),
                        decorator: const DotsDecorator(
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
                                productPrice.price == 0.0
                                    ? const SizedBox.shrink()
                                    : Text(
                                        productPrice.price.toStringAsFixed(0) +
                                            "₽",
                                        style: const TextStyle(fontSize: 32)),
                                const SizedBox(width: 10),
                                productPrice.oldPrice == null
                                    ? const SizedBox.shrink()
                                    : CustomPaint(
                                        painter: RedLine(),
                                        child: Text(
                                            productPrice.oldPrice!
                                                    .toStringAsFixed(0) +
                                                "₽",
                                            style: const TextStyle(
                                                fontSize: 32,
                                                color: Colors.black45)),
                                      ),
                              ],
                            ),
                            Row(
                              children: productInfo.attributes
                                  .map((element) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: ChoiceChip(
                                          visualDensity: VisualDensity.compact,
                                          labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          selectedColor:
                                              hexToColor(element.color),
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
                                  style: const TextStyle(fontSize: 20)),
                            ),
                            Text(productInfo.comment ?? "",
                                style: const TextStyle(fontSize: 16.0)),
                            Column(
                                children: productInfo.characteristics
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
                            const SizedBox(height: 16),
                            ExpandableTheme(
                              data: const ExpandableThemeData(
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
                                      header: const Text("Характеристики",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      collapsed: const SizedBox.shrink(),
                                      expanded: Column(
                                          children: productInfo.characteristics
                                              .map((e) => TextCharacteristic(
                                                  element: e))
                                              .toList()
                                              .cast<Widget>()),
                                    ),
                                  ExpandablePanel(
                                    header: const Text("Описание",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    collapsed: const SizedBox.shrink(),
                                    expanded: MarkdownBody(
                                        data: productInfo.description ?? ""),
                                  ),
                                  ExpandablePanel(
                                    header: const Text("Состав",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    collapsed: const SizedBox.shrink(),
                                    expanded: Column(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: productInfo.compositions
                                                .map((element) {
                                                  return Image.network(
                                                    element.picture ?? "",
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
                                    header: const Text("Отзывы",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    collapsed: const SizedBox.shrink(),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        OutlinedButton(
                                            child: const Text("НАПИСАТЬ ОТЗЫВ"),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              16.0)),
                                                ),
                                                builder: (context) {
                                                  return ReviewPage(
                                                      id: widget.id);
                                                },
                                              );
                                            }),
                                        Column(
                                            children: productInfo.reviews
                                                .map((element) =>
                                                    Text(element.text ?? ""))
                                                .toList()
                                                .cast<Widget>())
                                      ],
                                    ),
                                  ),
                                  if (productInfo.link.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 24),
                                        const Text("С этим берут",
                                            style: TextStyle(fontSize: 32)),
                                        const SizedBox(height: 12),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: productInfo.link
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
                                  if (productInfo.similar.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 48),
                                        const Text("Похожие товары",
                                            style: TextStyle(fontSize: 32)),
                                        const SizedBox(height: 12),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: productInfo.similar
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
                              document: gql(cartAdd),
                              onCompleted: (resultData) {
                                //print(resultData);

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Добавлен в корзину'),
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
                                      "В КОРЗИНУ • ${productPrice.price.toStringAsFixed(0)}₽",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      )));
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Mutation(
                          options: MutationOptions(
                            document: gql(setFavoritesProduct),
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
                                  ? const Icon(Icons.favorite_outlined)
                                  : const Icon(Icons.favorite_border_outlined),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(48, 48),
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
