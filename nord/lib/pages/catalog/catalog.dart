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

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
/*       tabController
          .animateTo(itemPositionsListener.itemPositions.value.first.index); */
      if (itemPositionsListener.itemPositions.value.first.index !=
              tabController.index &&
          noFlick == false) {
        tabController
            .animateTo(itemPositionsListener.itemPositions.value.first.index);
      }
      //print(itemPositionsListener.itemPositions.value.first.index);
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
            return ErrorPage(reload: () {
              refetch!();
            });
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

          nordCatalog.addAll([
            GraphCatalog(iD: 12, name: 'AAAA', products: [
              GraphProduct(
                  iD: 12,
                  familyID: 23,
                  topCatalogID: 43,
                  name: 'sdsd',
                  isFavorite: true,
                  favorites: 10,
                  stickerPictures: [],
                  attributes: []),
              GraphProduct(
                  iD: 12,
                  familyID: 23,
                  topCatalogID: 43,
                  name: 'sdsd',
                  isFavorite: true,
                  favorites: 10,
                  stickerPictures: [],
                  attributes: []),
              GraphProduct(
                  iD: 12,
                  familyID: 23,
                  topCatalogID: 43,
                  name: 'sdsd',
                  isFavorite: true,
                  favorites: 10,
                  stickerPictures: [],
                  attributes: []),
            ]),
            GraphCatalog(iD: 12, name: 'BBBB', products: [
              GraphProduct(
                  iD: 12,
                  familyID: 23,
                  topCatalogID: 43,
                  name: 'sdsd',
                  isFavorite: true,
                  favorites: 10,
                  stickerPictures: [],
                  attributes: []),
              GraphProduct(
                  iD: 12,
                  familyID: 23,
                  topCatalogID: 43,
                  name: 'sdsd',
                  isFavorite: true,
                  favorites: 10,
                  stickerPictures: [],
                  attributes: []),
              GraphProduct(
                  iD: 12,
                  familyID: 23,
                  topCatalogID: 43,
                  name: 'sdsd',
                  isFavorite: true,
                  favorites: 10,
                  stickerPictures: [],
                  attributes: []),
            ])
          ]);

          if (favMode) {
            for (final element in nordCatalog) {
              element.products.retainWhere((product) => product.isFavorite);
            }
            nordCatalog.retainWhere((element) => element.products.isNotEmpty);
          }

          tabController =
              TabController(length: nordCatalog.length, vsync: this);

          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AddressTile2(),
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
                  TabBar(
                    controller: tabController,
                    indicatorPadding: EdgeInsets.only(bottom: 8.0),
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: (newPage) async {
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

/*                       [
                      Tab(text: "Выпечка"),
                      Tab(text: "Кексы"),
                      Tab(text: "Конфеты"),
                      Tab(text: "Мороженое"),
                      Tab(text: "Выпечка"),
                      Tab(text: "Кексы"),
                      Tab(text: "Конфеты"),
                      Tab(text: "Мороженое"),
                    ], */
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await refetch!();
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ScrollablePositionedList.builder(
                          itemCount: nordCatalog.length,
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(nordCatalog[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                  const SizedBox(height: 12),
                                  Wrap(
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
                                                                id: product
                                                                    .iD)));
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
                  ),
                ],
              ),
            ),
          );
        });
  }
}
