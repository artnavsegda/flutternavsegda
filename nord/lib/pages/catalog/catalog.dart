import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/pages/error/error.dart';

import '../../components/components.dart';
import '../../components/product_card.dart';
import '../../gql.dart';
import '../product/product.dart';
import 'search.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage>
    with TickerProviderStateMixin {
  bool favMode = false;
  bool noFlick = false;
  bool headerUp = false;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late TabController tabController =
      TabController(length: 0, vsync: this, initialIndex: 0);
  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
      ItemPosition lowestPosition = itemPositionsListener.itemPositions.value
          .reduce((value, element) =>
              value.index > element.index ? element : value);

      if (!noFlick) initialIndex = lowestPosition.index;

      if (lowestPosition.index != tabController.index && noFlick == false) {
        tabController.animateTo(lowestPosition.index);
      }

      //if (!noFlick) {
      if (headerUp) {
        if (lowestPosition.index == 0 &&
            lowestPosition.itemLeadingEdge == 0.0) {
          setState(() {
            headerUp = false;
          });
        }
      } else {
        if (lowestPosition.index > 0 || lowestPosition.itemLeadingEdge < 0.0) {
          setState(() {
            headerUp = true;
          });
        }
      }
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getProducts),
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

          List<GraphCatalog> nordCatalog = List<GraphCatalog>.from(result
              .data!['getProducts']
              .map((model) => GraphCatalog.fromJson(model)));

          if (favMode) {
            for (final element in nordCatalog) {
              element.products.retainWhere((product) => product.isFavorite);
            }
            nordCatalog.retainWhere((element) => element.products.isNotEmpty);
          }

          if (tabController.length != nordCatalog.length)
            tabController = TabController(
                length: nordCatalog.length,
                vsync: this,
                initialIndex: initialIndex >= nordCatalog.length
                    ? nordCatalog.length - 1
                    : initialIndex);

          return Scaffold(
            appBar: AppBar(
              elevation: headerUp ? 3 : null,
              toolbarHeight: 120,
              flexibleSpace: SafeArea(
                  child: Column(
                children: [
                  AddressTile2(),
                  Row(
                    children: [
                      const SizedBox(width: 16.0),
                      Flexible(
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchPage()));
                          },
                          decoration: InputDecoration(
                              hintText: 'Найти в каталоге',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.0),
                                ),
                              ),
                              filled: true),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: favMode
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            minimumSize: const Size(36.0, 36.0),
                            padding: const EdgeInsets.all(0.0)),
                        onPressed: () {
                          setState(() {
                            favMode = !favMode;
                          });
                        },
                        child: Icon(
                          favMode
                              ? SeverMetropol.Icon_Favorite
                              : SeverMetropol.Icon_Favorite_Outlined,
                          color: favMode
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ],
              )),
              bottom: TabBar(
                controller: tabController,
                indicatorPadding: EdgeInsets.only(bottom: 8.0),
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                onTap: (newPage) async {
                  initialIndex = newPage;
                  noFlick = true;
                  await itemScrollController.scrollTo(
                      index: newPage,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOutCubic);
                  noFlick = false;
                },
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                labelColor: Colors.black38,
                tabs: nordCatalog
                    .map((category) => Tab(text: category.name))
                    .toList()
                    .cast<Widget>(),
              ),
            ),
            body: Material(
              color: Colors.white,
              child: RefreshIndicator(
                onRefresh: () async {
                  await refetch!();
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ScrollablePositionedList.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: nordCatalog.length,
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(nordCatalog[index].name,
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            //spacing: 8.0,
                            runSpacing: 32.0,
                            children: nordCatalog[index]
                                .products
                                .map((product) => ProductCard(
                                      product: product,
                                      onTap: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(
                                                        id: product.iD)));
                                        refetch!();
                                      },
                                    ))
                                .toList()
                                .cast<Widget>(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
