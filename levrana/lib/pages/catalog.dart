import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levrana/pages/product.dart';

const String getCatalog = r'''
query getCatalog {
  getCatalog {
    iD
    name
    totalCount
    childs {
      name
      iD
      totalCount
      childs {
        name
        iD
        totalCount
        childs {
          name
          iD
          totalCount
        }
      }
    }
  }
}
''';

const String getProducts = r'''
query getProducts($catalogID: Int!, $cursor: String) {
  getProducts(catalogID: $catalogID, first: 5, after: $cursor)
  {
    totalCount
    pageInfo {
      endCursor
      hasNextPage
      hasPreviousPage
      startCursor
    }
    items {
      iD
      name
      picture
    }
  }
}
''';

class CatalogPage extends StatelessWidget {
  CatalogPage(
      {Key? key,
      required this.catalog,
      required this.title,
      this.id = 0,
      this.totalCount = 0})
      : super(key: key);

  final List catalog;
  final String title;
  final int id;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          if (id != 0)
            ListTile(
              title: Text(
                "Вся продукция раздела",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              trailing: Text(
                totalCount.toString(),
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onTap: () {
                print(id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductsListPage(catalogId: id, title: title)));
              },
            ),
          Expanded(
            child: ListView.separated(
              itemCount: catalog.length,
              itemBuilder: (context, index) {
                final section = catalog[index];

                return ListTile(
                  dense: true,
                  title: Text(
                    section['name'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: (section['childs'] == null)
                      ? Text(section['totalCount'].toString(),
                          style: TextStyle(fontSize: 16.0))
                      : Icon(Icons.navigate_next),
                  onTap: () {
                    if (section['childs'] != null)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CatalogPage(
                                  catalog: section['childs'],
                                  title: section['name'],
                                  id: section['iD'],
                                  totalCount: section['totalCount'])));
                    else {
                      print(section['iD'].toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsListPage(
                                  catalogId: section['iD'],
                                  title: section['name'])));
                    }
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({Key? key, this.catalogId = 0, this.title = "Каталог"})
      : super(key: key);

  final int catalogId;
  final String title;

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late ScrollController _controller;

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FiltersPage()));
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getProducts),
          variables: {'catalogID': widget.catalogId, 'cursor': null},
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

              return fetchMoreResultData;
            },
          );

          _controller.addListener(() {
            if (_controller.offset >= _controller.position.maxScrollExtent &&
                !_controller.position.outOfRange) {
              fetchMore!(opts);
            }
          });

          return GridView.count(
              controller: _controller,
              crossAxisCount: 2,
              childAspectRatio: 0.8,
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
                    ),
                  ),
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

class FiltersPage extends StatelessWidget {
  const FiltersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Фильтры"),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text(
                'Сбросить',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 92,
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromRGBO(255, 162, 76, 0.22),
                          Color.fromRGBO(255, 162, 76, 0)
                        ]),
                    color: Color(0xffFFF2C4),
                  ),
                  child: Center(
                      child: Text("Подобрать косметику в конфигураторе"))),
            ),
            Text("Hello"),
          ],
        ));
  }
}

class CatalogNavigator extends StatefulWidget {
  const CatalogNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _CatalogNavigatorState createState() => _CatalogNavigatorState();
}

class _CatalogNavigatorState extends State<CatalogNavigator>
    with AutomaticKeepAliveClientMixin<CatalogNavigator> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
          builder: (BuildContext context) => Query(
                options: QueryOptions(
                  document: gql(
                      getCatalog), // this is the query string you just created
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading && result.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List catalog = result.data!['getCatalog'];

                  return CatalogPage(
                    catalog: catalog,
                    title: "Каталог",
                  );
                },
              ),
          settings: settings),
    );
  }
}
