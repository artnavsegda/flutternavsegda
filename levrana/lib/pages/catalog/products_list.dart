import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:levrana/pages/product/product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../gql.dart';
import '../../components/product_card.dart';
import 'filter.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage(
      {Key? key, required this.catalogId, this.title = "Каталог"})
      : super(key: key);

  final int catalogId;
  final String title;

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late ScrollController _controller;

  GraphFilter catalogFilter = GraphFilter();

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Image(
                image: AssetImage('assets/ic-24/icon-24-search.png')),
            onPressed: () {},
          ),
          IconButton(
            icon: const Image(
                image: AssetImage('assets/ic-24/icon-24-filter-menu.png')),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FiltersPage(
                            catalogId: widget.catalogId,
                            filter: catalogFilter,
                            onFilterChanged: (newFilter) {
                              setState(() {
                                catalogFilter = newFilter;
                              });
                            },
                          )));
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getProducts),
          variables: {
            'catalogID': widget.catalogId,
            'cursor': null,
            'filter': catalogFilter
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
        builder: (QueryResult result, {refetch, FetchMore? fetchMore}) {
          //print(jsonEncode(catalogFilter));

          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final GraphProductConnection productConnection =
              GraphProductConnection.fromJson(result.data!['getProducts']);
          final List<GraphProduct> items = productConnection.items;

          final PageInfo pageInfo = productConnection.pageInfo;
          final String fetchMoreCursor = pageInfo.endCursor ?? "";

          FetchMoreOptions opts = FetchMoreOptions(
            variables: {'cursor': fetchMoreCursor},
            updateQuery: (previousResultData, fetchMoreResultData) {
              //print(fetchMoreResultData!['getProducts']['items']);

              final List<dynamic> items = [
                ...previousResultData!['getProducts']['items'] as List<dynamic>,
                ...fetchMoreResultData!['getProducts']['items'] as List<dynamic>
              ];

              // to avoid a lot of work, lets just update the list of repos in returned
              // data with new data, this also ensures we have the endCursor already set
              // correctly
              fetchMoreResultData['getProducts']['items'] = items;

              return fetchMoreResultData;
            },
          );

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                if (_controller.offset + 100 >=
                        _controller.position.maxScrollExtent &&
                    !_controller.position.outOfRange &&
                    pageInfo.hasNextPage) {
                  fetchMore!(opts);
                }
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  await refetch!();
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  controller: _controller,
                  crossAxisCount: 2,
                  itemCount: items.length + (pageInfo.hasNextPage ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) =>
                      (index == items.length && pageInfo.hasNextPage)
                          ? const Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProductCard(
                                  product: items[index],
                                  onTap: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                            builder: (context) => ProductPage(
                                                id: items[index].iD)),
                                      )),
                            ),
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
