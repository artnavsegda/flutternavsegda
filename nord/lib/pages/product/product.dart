import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:provider/provider.dart';
import 'package:nord/login_state.dart';
import 'package:nord/components/components.dart';
import 'package:nord/utils.dart';

import 'review.dart';
import 'set.dart';
import 'package:nord/gql.dart';
import '../error/error.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int page = 0;
  bool headerUp = false;
  bool scrollAtBottom = false;
  final _controller = PageController();
  final _scrollController = ScrollController();
  late FToast fToast;

  void checkPos() {
    if (_scrollController.offset > 50 && headerUp == false) {
      setState(() {
        headerUp = true;
      });
    } else if (_scrollController.offset < 51 && headerUp == true) {
      {
        setState(() {
          headerUp = false;
        });
      }
    }

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        scrollAtBottom == false) {
      setState(() {
        scrollAtBottom = true;
      });
    } else if (_scrollController.offset <
            _scrollController.position.maxScrollExtent &&
        scrollAtBottom == true) {
      setState(() {
        scrollAtBottom = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(checkPos);

    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
//          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql(getProduct),
          variables: {
            'productID': widget.id,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return ErrorPage(
              reload: () {
                refetch!();
              },
              errorText: result.exception?.graphqlErrors[0].message ?? '',
            );
          }

          if (result.isLoading && result.data == null) {
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          GraphProductCard productInfo =
              GraphProductCard.fromJson(result.data!['getProduct']);

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  elevation: headerUp ? 5 : null,
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          SeverMetropol.Icon_Share,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    SizedBox(width: 10),
                  ],
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        SeverMetropol.Icon_West,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ),
                body: ListView(
                  controller: _scrollController,
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 270,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          productInfo.pictures.length > 0
                              ? PageView(
                                  controller: _controller,
                                  children: productInfo.pictures
                                      .map((picture) => CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: picture.full,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: Colors.white,
                                                highlightColor:
                                                    const Color(0xFFECECEC),
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: const Color(0xFFECECEC),
                                                child: Center(
                                                    child: const Icon(
                                                        Icons.no_photography)),
                                              )))
                                      .toList()
                                      .cast<Widget>(),
                                )
                              : Container(
                                  color: const Color(0xFFECECEC),
                                  child: Center(
                                      child: const Icon(Icons.no_photography)),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SmoothPageIndicator(
                                controller: _controller,
                                count: productInfo.pictures.length,
                                effect: const ExpandingDotsEffect(
                                  spacing: 4.0,
                                  //radius: 4.0,
                                  dotWidth: 5.0,
                                  dotHeight: 5.0,
                                  expansionFactor: 6,
                                  dotColor: Color.fromRGBO(255, 255, 255, 0.5),
                                  activeDotColor: Colors.white,
                                ),
                                onDotClicked: (index) {}),
                          ),
                          Positioned(
                              child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                BadgeIcon(
                                  title: 'ЗОЖ',
                                  color: Color(0xFFA4D65E),
                                ),
                                BadgeIcon(
                                  title: 'От шефа',
                                  color: Color(0xFFD2AB67),
                                ),
                                BadgeIcon(
                                  title: 'С собой',
                                  color: Color(0xFFB0063A),
                                ),
                                ...productInfo.awards
                                    .map((e) => Image.network(e.picture))
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (productInfo.prices.isNotEmpty)
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.ideographic,
                                  children: [
                                    Text(
                                      productInfo.prices[0].price
                                              .toInt()
                                              .toString() +
                                          ' ₽ ',
                                      style: TextStyle(
                                          fontFamily: 'Forum',
                                          fontSize: 34,
                                          fontFamilyFallback: [
                                            'Noto Sans',
                                            'Roboto',
                                          ]),
                                    ),
                                    if (productInfo.prices[0].oldPrice != null)
                                      CustomPaint(
                                        painter: RedLine(),
                                        child: Text('420 ₽',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(color: Colors.grey)),
                                      ),
                                  ],
                                ),
                              Row(
                                children: [
                                  Tooltip(
                                      preferBelow: false,
                                      triggerMode: TooltipTriggerMode.tap,
                                      message:
                                          'Стоимость в приложении может отличаться от стоимости в кафе. Для уточнения стоимости товара, выберите способ и место его получения.',
                                      child: Text(
                                        'Базовая цена. ',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )),
                                  const Text('За 1 шт.'),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    SeverMetropol.Icon_Star_Rate,
                                    color: Color(0xFFD2AB67),
                                  ),
                                  Text('4.7'),
                                ],
                              ),
                              Text('13 отзывов'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Вес, гр'),
                          Row(
                            children: [
                              ChoiceChip(
                                backgroundColor: Colors.transparent,
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                    width: 1.0,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                labelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: Text('50'),
                                selected: false,
                                onSelected: (value) {},
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              SizedBox(width: 8),
                              ChoiceChip(
                                backgroundColor: Colors.transparent,
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                    width: 1.0,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                label: Text('100'),
                                selected: true,
                                onSelected: (value) {},
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              SizedBox(width: 8),
                              ChoiceChip(
                                backgroundColor: Colors.transparent,
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                    width: 1.0,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                labelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: Text('250'),
                                selected: false,
                                onSelected: (value) {},
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              SizedBox(width: 8),
                              ChoiceChip(
                                backgroundColor: Colors.transparent,
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                    width: 1.0,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                labelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: Text('1000'),
                                selected: false,
                                onSelected: (value) {},
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DefaultTabController(
                      length: 3,
                      child: TabBar(
                        indicatorPadding: EdgeInsets.only(bottom: 8.0),
                        indicatorSize: TabBarIndicatorSize.label,
                        /*                   indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.redAccent), */
                        onTap: (newPage) {
                          setState(() {
                            page = newPage;
                          });

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            checkPos();
                          });
                        },
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.primary,
                        labelColor: Colors.black38,
                        tabs: const [
                          Tab(text: "О продукте"),
                          Tab(text: "Состав"),
                          Tab(text: "Отзывы"),
                        ],
                      ),
                    ),
                    [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: const [
                                  Text('36 часов'),
                                  Text(
                                    'Срок хранения',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                ],
                              ),
                              Column(
                                children: const [
                                  Text('3-25℃ – +25℃'),
                                  Text(
                                    'Условия хранения',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: Text(
                                                'Пищевая ценность на 100 г'),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  SeverMetropol.Icon_Close,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '490.8 Ккал',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    const Text(
                                      'Калорийность',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(productInfo.description ??
                                'Пирожное состоит из воздушного безе, прослоенного натуральным шоколадом и нежным воздушным кремом из белого шоколада и натуральных сливок. Украшено свежими фруктами и ягодами по сезону: клубникой, ежевикой, малиной, физалисом, голубикой, красной смородиной, киви. Присыпано сахарной пудрой, украшено декором и шоколадной глазурью.'),
                          ),
                          SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text('Какая-то причуда'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('Неизвстное')
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text('ШxДxВ'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('10X15X25 см'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text('Материал'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('Кожа, бархат, кровь')
                              ],
                            ),
                          ),
                          ...productInfo.characteristics
                              .where((e) => e.type == 'TEXT')
                              .map((e) => TextCharacteristic(element: e)),
                          SizedBox(height: 24),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(productInfo.composition ??
                            'Мука в/с, сахар, кондитерский жир, яичный желток, сахарная пудра, яичный белок, какао порошок, пищевые красители, ванилин, пищевая сода, лимонная кислота.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Отзывов о товаре пока нет',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            const Text(
                                'Будьте первыми. Поделитесь, всё ли понравилось? Мы внимательно изучим Ваше мнение, чтобы знать, как сделать качество продукции лучше.'),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ReviewPage()));
                                  },
                                  child: const Text('Оставить отзыв')),
                            )
                          ],
                        ),
                      )
                    ][page],
                  ],
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: scrollAtBottom
                        ? null
                        : [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Color(0x24000000),
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            )
                          ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Mutation(
                          options: MutationOptions(
                            document: gql(cartAdd),
                            onError: (error) {
                              print('error: $error');
                              showErrorAlert(context, '$error');
                            },
                            onCompleted: (resultData) {
                              if (resultData != null) {
                                GraphBasisResult nordBasisResult =
                                    GraphBasisResult.fromJson(
                                        resultData['cartAdd']);

                                if (nordBasisResult.result == 0) {
                                  context
                                      .read<CartState>()
                                      .addToCart(id: widget.id);

                                  fToast.showToast(
                                      child:
                                          NordToast("Товар добавлен в корзину"),
                                      gravity: ToastGravity.TOP,
                                      toastDuration: Duration(seconds: 1),
                                      positionedToastBuilder: (context, child) {
                                        return Positioned(
                                          child: child,
                                          right: 16.0,
                                          left: 16.0,
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              4,
                                        );
                                      });
                                } else {
                                  showErrorAlert(context,
                                      nordBasisResult.errorMessage ?? '');
                                }
                              }
                            },
                          ),
                          builder: (runMutation, result) {
                            return GradientButton(
                              onPressed: () async {
                                if (productInfo.type == "ADDITION") {
                                  for (final modifier
                                      in productInfo.modifiers) {
                                    await showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(4.0)),
                                      ),
                                      backgroundColor: Colors.white,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return ExtraIngredientBottomSheet(
                                            modifier: modifier);
                                      },
                                    );
                                  }
                                } else if (productInfo.type == "BOX") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SetPage()));
                                }

                                runMutation({'productID': widget.id});
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Добавить в корзину'),
                                    if (productInfo.prices.isNotEmpty)
                                      Text(productInfo.prices[0].price
                                              .toInt()
                                              .toString() +
                                          ' Р')
                                  ]),
                            );
                          },
                        ),
                      ),
                      Mutation(
                        options: MutationOptions(
                          document: gql(setFavoritesProduct),
                          onCompleted: (resultData) {
                            refetch!();
                          },
                        ),
                        builder: (runMutation, result) {
                          return TextButton.icon(
                            onPressed: () async {
                              runMutation({'productID': widget.id});
                            },
                            icon: Icon(
                              productInfo.isFavorite
                                  ? SeverMetropol.Icon_Favorite
                                  : SeverMetropol.Icon_Favorite_Outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text('${productInfo.favorites}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                top: MediaQuery.of(context).padding.top + (headerUp ? 18 : 60),
                left: headerUp ? 72 : 16,
                right: headerUp ? 72 : 16,
                child: AnimatedDefaultTextStyle(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 400),
                  style: TextStyle(
                    fontFamily: 'Forum',
                    color: Colors.black,
                    fontSize: headerUp ? 20 : 34,
                  ),
                  child: AnimatedAlign(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 400),
                    alignment:
                        headerUp ? Alignment.center : Alignment.centerLeft,
                    child: Text(
                      productInfo.name,
                      //softWrap: headerUp ? false : true,
                      overflow: headerUp ? TextOverflow.ellipsis : null,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class ExtraIngredientBottomSheet extends StatelessWidget {
  const ExtraIngredientBottomSheet({
    Key? key,
    required this.modifier,
  }) : super(key: key);

  final GraphModifier modifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(modifier.caption ?? 'Дополнительный ингредиент'),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Без дополнительных'),
              Text('0 Р'),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ...modifier.products.map((product) => ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.name),
                  Text('${product.prices[0].price} Р'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ))
      ],
    );
  }
}

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
          alignment: Alignment.bottomLeft,
          color: color,
          child: Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.white, height: 1.1),
          ),
        ),
      ),
    );
  }
}
