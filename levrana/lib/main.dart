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
import 'pages/login.dart';

void main() async {
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://demo.cyberiasoft.com/levranaservice/graphql',
  );

  final AuthLink authLink = AuthLink(getToken: () async {
    final prefs = await SharedPreferences.getInstance();
    print("DEBUG TOKEN " + (prefs.getString('token') ?? ""));
    return 'Bearer ' + (prefs.getString('token') ?? "");
  });

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

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: FutureBuilder<String>(
          future: getToken(),
          builder: (buildContext, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == "") {
                return Welcome();
              } else {
                return LoginPage();
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

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
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
            print(index);
            setState(() {
              _selectedIndex = index;
            });
          },
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
