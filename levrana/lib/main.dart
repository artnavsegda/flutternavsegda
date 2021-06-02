import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

const String getCatalog = """
query getCatalog {
  getCatalog {
    iD
    name
    picture
    childs {
      name
      iD
      childs {
        name
        iD
        childs {
          name
          iD
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
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _catalogID = 0;
  List _catalog = [];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Каталог",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Query(
        options: QueryOptions(
          document:
              gql(getCatalog), // this is the query string you just created
        ),
        // Just like in apollo refetch() could be used to manually trigger a refetch
        // while fetchMore() can be used for pagination purpose
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
          if (_catalog.length != 0) catalog = _catalog;

          return ListView.separated(
            itemCount: catalog.length,
            itemBuilder: (context, index) {
              final section = catalog[index];

              return ListTile(
                dense: true,
                title: Text(
                  section['name'],
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  print(section['iD']);
                  setState(() {
                    _catalog = section['childs'];
                  });
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
          );
        },
      )),
/*       floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),  */ // This trailing comma makes auto-formatting nicer for build methods.
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
