import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../components/components.dart';
import '../../components/product_card.dart';
import '../../gql.dart';
import 'search.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();

    return Query(
        options: QueryOptions(
          document: gql(getProducts),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading || result.hasException) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<GraphCatalog> nordCatalog = List<GraphCatalog>.from(result
              .data!['getProducts']
              .map((model) => GraphCatalog.fromJson(model)));

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
                            minimumSize: const Size(36.0, 36.0),
                            padding: const EdgeInsets.all(0.0)),
                        onPressed: () {},
                        child: Image.asset('assets/Icon-Favorite-Outlined.png'),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                  DefaultTabController(
                    length: nordCatalog.length,
                    child: TabBar(
                      indicatorPadding: EdgeInsets.only(bottom: 8.0),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: (newPage) {
                        itemScrollController.scrollTo(
                            index: newPage,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOutCubic);
                      },
                      unselectedLabelColor: Colors.red.shade900,
                      labelColor: Colors.black38,
                      tabs: nordCatalog
                          .map((category) {
                            return Tab(text: category.name);
                          })
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
                  ),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemCount: nordCatalog.length,
                      itemScrollController: itemScrollController,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nordCatalog[index].name,
                                  style: TextStyle(
                                      fontFamily: 'Forum', fontSize: 24.0)),
                              const SizedBox(height: 12),
                              Wrap(
                                //spacing: 8.0,
                                runSpacing: 32.0,
                                children: nordCatalog[index]
                                    .products
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
