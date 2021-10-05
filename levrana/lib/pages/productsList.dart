import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:levrana/pages/product.dart';

import '../gql.dart';
import '../components.dart';
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

  bool fetchingMore = false;
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
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("${widget.title}", style: TextStyle(color: Colors.black)),
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FiltersPage(
                          catalogId: widget.catalogId, filter: catalogFilter)));
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
        ),
        builder: (QueryResult result, {refetch, FetchMore? fetchMore}) {
          print(result);

          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading && result.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final items = (result.data!['getProducts']['items'] as List<dynamic>);

          final Map pageInfo = result.data!['getProducts']['pageInfo'];
          final String fetchMoreCursor = pageInfo['endCursor'];

          FetchMoreOptions opts = FetchMoreOptions(
            variables: {'cursor': fetchMoreCursor},
            updateQuery: (previousResultData, fetchMoreResultData) {
              final List<dynamic> items = [
                ...previousResultData!['getProducts']['items'] as List<dynamic>,
                ...fetchMoreResultData!['getProducts']['items'] as List<dynamic>
              ];

              // to avoid a lot of work, lets just update the list of repos in returned
              // data with new data, this also ensures we have the endCursor already set
              // correctly
              fetchMoreResultData['getProducts']['items'] = items;

              setState(() {
                fetchingMore = false;
              });

              return fetchMoreResultData;
            },
          );

          _controller.addListener(() {
            if (_controller.offset + 100 >=
                    _controller.position.maxScrollExtent &&
                !_controller.position.outOfRange) {
              setState(() {
                fetchingMore = true;
              });
              fetchMore!(opts);
            }
          });

          return GridView.count(
              controller: _controller,
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              children: [
/*                 ElevatedButton(
                    onPressed: () {
                      fetchMore!(opts);
                    },
                    child: Text("More")), */
                for (var item in items)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductCard(
                        product: item,
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductPage(id: item['iD'])),
                            )),
                  ),
                if (fetchingMore)
                  Center(
                    child: CircularProgressIndicator(),
                  )
/*                 TextButton(
                    onPressed: () {
                      fetchMore!(opts);
                    },
                    child: Text("More")), */
              ]);

          /*return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return GridTile(
                  child:
                      Text(result.data!['getProducts']['items'][index]['name']),
                );
              });*/
        },
      ),
    );
  }
}
