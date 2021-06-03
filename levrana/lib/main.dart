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

void main() async {
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://demo.cyberiasoft.com/levranaservice/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () async =>
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4ODAxMWM3Yi03MDE1LTRkNDAtYTUzYS04ZGIyMzc4YTJiMTMiLCJkZXZpY2VJZCI6ImhlbGxvIiwib1NUeXBlIjoiMSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkRldmljZSIsImV4cCI6MzMxNDc4MjkxODEsImlzcyI6IkxldnJhbmEiLCJhdWQiOiJDeWJlcmlhU29mdCJ9.S4DL2jgnDJYbUWwtfozOr9H2yQpuKEnYEvmnKbLqyC8',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MainPage(),
      ),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({
    Key? key,
    required this.catalog,
    required this.title,
  }) : super(key: key);

  final List catalog;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: ListView.separated(
        itemCount: catalog.length,
        itemBuilder: (context, index) {
          final section = catalog[index];

          return ListTile(
            dense: true,
            title: Text(
              section['name'],
              style: GoogleFonts.montserrat(fontSize: 16),
            ),
            trailing: Text(
                section['totalCount'].toString()), //Icon(Icons.navigate_next),
            onTap: () {
              //print(section['childs']);
              //print(section['iD']);
              print(section['totalCount']);
              if (section['childs'] != null)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CatalogPage(
                              catalog: section['childs'],
                              title: section['name'],
                            )));
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
                    print(result.data!['getCatalog']);
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
              icon: Image(image: AssetImage('assets/ic-24/icon-24-user.png')),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Image(
                  image: AssetImage('assets/ic-24/icon-24-catalog-v3.png')),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon:
                  Image(image: AssetImage('assets/ic-24/icon-24-shopping.png')),
              label: 'School',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/ic-24/icon-24-user.png')),
              label: 'School',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/ic-24/icon-24-user.png')),
              label: 'School',
            ),
          ],
        ),
      ),
    );
  }
}
