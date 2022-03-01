import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'router/routes.dart';
import 'utils.dart';
import 'login_state.dart';

Future<void> main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

/*   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); */

  initializeDateFormatting();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(NordApp(
    loginState: LoginState(prefs),
    cartState: CartState(prefs),
  ));
}

class NordApp extends StatelessWidget {
  final LoginState loginState;
  final CartState cartState;

  const NordApp({
    Key? key,
    required this.loginState,
    required this.cartState,
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
          fontSize: 24.0,
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          lazy: false,
          create: (context) => loginState,
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => cartState,
        ),
        Provider<NordRouter>(
          lazy: false,
          create: (context) => NordRouter(loginState),
        ),
      ],
      child: Consumer<LoginState>(
        builder: (BuildContext context, model, child) {
          final router = Provider.of<NordRouter>(context, listen: false).router;
          return GraphQLProvider(
            client: ValueNotifier(
              GraphQLClient(
                link: AuthLink(getToken: () => 'Bearer ' + model.token).concat(
                  HttpLink(
                    'https://demo.cyberiasoft.com/severmetropolservice/graphql',
                  ),
                ),
                cache: GraphQLCache(store: HiveStore()),
              ),
            ),
            child: MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: 'Север Метрополь',
              theme: nordTheme,
            ),
          );
        },
      ),
    );
  }
}
