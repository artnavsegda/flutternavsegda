import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'pages/onboarding/welcome.dart';
import 'pages/onboarding/login.dart';
import 'pages/main.dart';

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
          //fetchPolicy: FetchPolicy.cacheFirst,
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
