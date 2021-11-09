import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'pages/catalog/catalog.dart';
import 'pages/home/home.dart';
import 'pages/more/more.dart';
import 'pages/shopping/shopping.dart';
import 'pages/user/user.dart';
import 'pages/login/welcome.dart';
import 'pages/login/login.dart';

import 'gql.dart';

void main() async {
  await initHiveForFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final prefs = await SharedPreferences.getInstance();
  final startToken = prefs.getString('token') ?? "";

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(token: startToken),
      child: LevranaApp(),
    ),
  );
}

class AppModel with ChangeNotifier {
  AppModel({required this.token});
  String token;

  setToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    this.token = newToken;
    prefs.setString('token', newToken);
    notifyListeners();
  }
}

class LevranaApp extends StatelessWidget {
  // This widget is the root of your application.

  const LevranaApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData levranaTheme = ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.green,
        fontFamily: 'Montserrat',
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
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
            )));

    return Consumer<AppModel>(builder: (context, model, child) {
      return GraphQLProvider(
        client: ValueNotifier(
          GraphQLClient(
            link: AuthLink(getToken: () => 'Bearer ' + model.token).concat(
              HttpLink(
                'https://demo.cyberiasoft.com/levranaservice/graphql',
              ),
            ),
            cache: GraphQLCache(store: HiveStore()),
          ),
        ),
        child: MaterialApp(
          //showPerformanceOverlay: true,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ru', ''), // English, no country codeish, no country code
          ],
          title: 'Levrana',
          theme: levranaTheme,
          home: model.token == "" ? Welcome() : StartRoute(),
        ),
      );
    });
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
    return Query(
        options: QueryOptions(
          document: gql(getReactions),
        ),
        builder: (result, {fetchMore, refetch}) {
          //print(result);

          if (!result.hasException) {
            if (result.isLoading && result.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (result.data!['getReactions'][0]['type'] == 'MESSAGE' && false) {
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                        result.data!['getReactions'][0]['message']['caption']),
                    content: Text(
                        result.data!['getReactions'][0]['message']['text']),
                    actions: [
                      Mutation(
                          options: MutationOptions(
                            document: gql(openReactionMessage),
                            onCompleted: (resultData) {
                              print(resultData);
                              refetch!();
                            },
                          ),
                          builder: (runMutation, mutationResult) {
                            return TextButton(
                              onPressed: () async {
                                await launch(result.data!['getReactions'][0]
                                    ['message']['uRL']);
                                runMutation({
                                  'messageID': result.data!['getReactions'][0]
                                      ['message']['iD']
                                });
                                Navigator.pop(context, 'OK');
                              },
                              child: Text(result.data!['getReactions'][0]
                                  ['message']['button']),
                            );
                          }),
                    ],
                  ),
                );
              });
            }
          }

          return Scaffold(
            body: TabBarView(
              controller: _tabController,
              children: [
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
                    icon: ImageIcon(
                        AssetImage('assets/ic-24/icon-24-catalog-v3.png')),
                    label: 'Catalog',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                        AssetImage('assets/ic-24/icon-24-shopping.png')),
                    label: 'Shopping',
                  ),
                  BottomNavigationBarItem(
                    icon:
                        ImageIcon(AssetImage('assets/ic-24/icon-24-user.png')),
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
        });
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
        options: QueryOptions(
          document: gql(getStartRoute),
          fetchPolicy: FetchPolicy.cacheFirst,
        ),
        builder: (result, {fetchMore, refetch}) {
          //print(result);
          if (result.hasException) {
            return LoginPage();
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
