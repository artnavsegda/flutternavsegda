import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/onboarding.dart';

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
      primarySwatch: Colors.green,
      fontFamily: 'Forum',
      textTheme: GoogleFonts.forumTextTheme(
        Theme.of(context).textTheme,
      ),
/*       elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          minimumSize: MaterialStateProperty.all(const Size(128.0, 48.0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      ), */
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: nordTheme,
      home: const Onboarding(),
    );
  }
}
