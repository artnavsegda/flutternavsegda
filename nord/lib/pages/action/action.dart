import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../components/product_card.dart';
import '../../components/components.dart';
import '../../gql.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  bool headerUp = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.offset > 0 && headerUp == false) {
          setState(() {
            headerUp = true;
          });
        } else if (_scrollController.offset < 1) {
          {
            setState(() {
              headerUp = false;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
//          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql(getAction),
          variables: {
            'actionID': widget.id,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: Text(
                result.exception.toString(),
              )),
            );
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          GraphActionCard action =
              GraphActionCard.fromJson(result.data!['getAction']);

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  //title: Text('Взрывная весна! Откр...'),
                  actions: [
                    Image.asset('assets/Icon-Share.png'),
                  ],
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset('assets/Icon-West.png')),
                ),
                body: ListView(
                  controller: _scrollController,
                  children: [
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Text(
                        '15 октября–27 ноября',
                        style: TextStyle(
                            fontFamily: 'Forum',
                            fontSize: 24,
                            color: Colors.grey),
                      ),
                    ),
                    CachedNetworkImage(
                        imageUrl: action.picture ?? "",
                        placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: const Color(0xFFECECEC),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                        errorWidget: (context, url, error) => Container(
                              color: const Color(0xFFECECEC),
                              child: Center(
                                  child: const Icon(Icons.no_photography)),
                            )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        action.description ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const SpecialCondition(
                        text:
                            'Успейте получить подарок, количество ограничено! Акция действует только в части наших кафе и кондитерских.',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Важно',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const Text(
                            '''Сумма чека должна быть не менее 500 рублей без учёта бонусов.
Приз выпадает за каждый чек на сумму более 500 рублей в акционный период.
                      
Подробнее об акции и условиях проведения читайте на сайте.''',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                            onPressed: () {},
                            label: Image.asset('assets/Icon-East.png'),
                            icon: const Text('Найти ближайшее кафе')),
                      ),
                    ),
                    if (action.type == 'PRODUCT') ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Товары, участвующие в акции',
                            style: TextStyle(
                              fontFamily: 'Forum',
                              fontSize: 24,
                            )),
                      ),
                      SizedBox(
                        height: 240,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            ...action.products
                                .map((product) {
                                  return ProductCard(
                                    productID: product.iD,
                                    productImage: product.picture ?? '',
                                    productName: product.name,
                                    productPrice: '420',
                                  );
                                })
                                .toList()
                                .cast<Widget>(),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                top: MediaQuery.of(context).padding.top + (headerUp ? 18 : 90),
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
                      action.name,
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
