import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'router/routes.dart';
import 'utils.dart';
import 'login_state.dart';

Future<void> main() async {
  //debugRepaintRainbowEnabled = true;
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(NordApp(
    prefs: prefs,
  ));
}

class NordApp extends StatelessWidget {
  final SharedPreferences prefs;

  const NordApp({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData nordTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: createMaterialColor(Color(0xFFCD0643)),
      fontFamily: 'Noto Sans',
      textTheme:
          GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme).copyWith(
        headlineSmall: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Forum',
          fontFamilyFallback: ['Roboto'],
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Forum',
          fontSize: 20.0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Colors.red.shade900),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          elevation: 0.0,
          minimumSize: const Size(111.0, 48.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
    );

    LoginState loginState = LoginState(prefs);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          lazy: false,
          create: (context) => loginState,
        ),
        ChangeNotifierProvider<CartState>(
          lazy: false,
          create: (context) => CartState(prefs),
        ),
        ChangeNotifierProvider<FilterState>(
          lazy: false,
          create: (context) => FilterState(prefs),
        ),
        Provider<NordRouter>(
          lazy: false,
          create: (context) => NordRouter(loginState),
        ),
      ],
      child: Consumer<LoginState>(
        builder: (context, model, child) {
          final router = context.read<NordRouter>().router;
          return GraphQLProvider(
            client: ValueNotifier(model.gqlClient),
            child: MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: 'Север Метрополь',
              theme: nordTheme,
              supportedLocales: [
                Locale('ru', 'RU'),
              ],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}
