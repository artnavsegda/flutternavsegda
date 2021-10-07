import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/catalog.dart';
import 'pages/home.dart';
import 'pages/more.dart';
import 'pages/shopping.dart';
import 'pages/user.dart';
import 'pages/dialog.dart';

void main() async {
  //await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://demo.cyberiasoft.com/levranaservice/graphql',
  );

  final AuthLink authLink = AuthLink(getToken: () async {
    final prefs = await SharedPreferences.getInstance();
    //print("DEBUG TOKEN " + (prefs.getString('token') ?? ""));
    return 'Bearer ' + (prefs.getString('token') ?? "");
  });

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: InMemoryStore()),
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

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    //print("STARTUP TOKEN" + (prefs.getString('token') ?? ""));
    return prefs.getString('token') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        //showPerformanceOverlay: true,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.green,
            fontFamily: 'Montserrat',
            textTheme: GoogleFonts.montserratTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: GoogleFonts.montserrat(
                  fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0.0),
                minimumSize: MaterialStateProperty.all(Size(128.0, 48.0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(width: 1.0, color: Colors.green)),
                elevation: MaterialStateProperty.all(0.0),
                minimumSize: MaterialStateProperty.all(Size(128.0, 48.0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ))),
        home: FutureBuilder<String>(
          future: getToken(),
          builder: (buildContext, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == "") {
                return Welcome();
              } else {
                return StartRoute();
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomePage(),
          CatalogNavigator(),
          ShoppingPage(),
          UserPage(),
          MorePage(),
        ],
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
          onTap: (index) {
            _tabController.animateTo(index);
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/ic-24/icons-home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  ImageIcon(AssetImage('assets/ic-24/icon-24-catalog-v3.png')),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/ic-24/icon-24-shopping.png')),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/ic-24/icon-24-user.png')),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/ic-24/icons-more.png')),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

const String getStartRoute = r'''
query getStartRoute {
  getClientInfo {
    clientGUID,
  }
}
''';

class StartRoute extends StatelessWidget {
  const StartRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getStartRoute)),
        builder: (result, {fetchMore, refetch}) {
          //print(result);
          if (result.hasException) {
            return LoginPage();
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return MainPage();
        });
  }
}
