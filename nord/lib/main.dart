import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/onboarding/onboarding.dart';
import 'pages/main.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      appBarTheme: AppBarTheme(
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
        style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(width: 1.0, color: Colors.red.shade900)),
          elevation: MaterialStateProperty.all(0.0),
//          minimumSize: MaterialStateProperty.all(const Size(128.0, 48.0)),
/*           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ), */
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          minimumSize: MaterialStateProperty.all(const Size(111.0, 48.0)),
        ),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: nordTheme,
      home: const Onboarding(),
    );
  }
}
