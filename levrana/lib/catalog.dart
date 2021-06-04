import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

const String getCatalog = """
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
""";

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
    print(catalog);
    print(id);
    print(totalCount);
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

class MainPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
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

                    // it can be either Map or List
                    //print(result.data!['getCatalog']);
                    List catalog = result.data!['getCatalog'];

                    return CatalogPage(
                      catalog: catalog,
                      title: "Каталог",
                    );
                  },
                ),
            settings: settings),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.07),
              blurRadius: 100.0,
              offset: Offset(0.0, -27),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.0417275),
              blurRadius: 22.3363,
              offset: Offset(0.0, -6.0308),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.0282725),
              blurRadius: 6.6501,
              offset: Offset(0.0, -1.79553),
            )
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/ic-24/icons-home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image(
                  image: AssetImage('assets/ic-24/icon-24-catalog-v3.png')),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon:
                  Image(image: AssetImage('assets/ic-24/icon-24-shopping.png')),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/ic-24/icon-24-user.png')),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/ic-24/icons-more.png')),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
