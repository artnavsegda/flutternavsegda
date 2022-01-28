import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'pages/onboarding/onboarding.dart';
import 'pages/main.dart';
import 'utils.dart';
import 'intro.dart';
import 'login_state.dart';

Future<void> main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  final state = LoginState(await SharedPreferences.getInstance());
  state.checkLoggedIn();
  runApp(NordApp(loginState: state));
}

class NordApp extends StatelessWidget {
  final LoginState loginState;

  const NordApp({Key? key, required this.loginState}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData nordTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: createMaterialColor(Colors.red.shade900),
      fontFamily: 'Noto Sans',
      textTheme: GoogleFonts.notoSansTextTheme(
        Theme.of(context).textTheme,
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
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
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
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

    return MaterialApp(
      title: 'Север Метрополь',
      theme: nordTheme,
      home: const MainPage(),
    );
  }
}
