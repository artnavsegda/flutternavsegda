import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
query getProducts($catalogID: Int!) {
  getProducts(catalogID: $catalogID, first: 5)
  {
    totalCount
    items {
      iD
      name
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
    //print(catalog);
    //print(id);
    //print(totalCount);
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
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
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                  trailing: (section['childs'] == null)
                      ? Text(section['totalCount'].toString(),
                          style: GoogleFonts.montserrat(fontSize: 16))
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

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key, this.catalogId = 0, this.title = "Каталог"})
      : super(key: key);

  final int catalogId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("$title", style: TextStyle(color: Colors.black)),
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
          variables: {
            'catalogID': catalogId,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          return Text("Hello");
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
        body: Center(
          child: Text("Hello"),
        ));
  }
}

class CatalogNavigator extends StatelessWidget {
  const CatalogNavigator({
    Key? key,
  }) : super(key: key);

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

                  if (result.isLoading) {
                    return Text('Loading');
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
