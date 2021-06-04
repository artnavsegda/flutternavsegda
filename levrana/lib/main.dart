import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'catalog.dart';

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
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: Welcome(),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image(image: AssetImage('assets/Приветствие@2x.png')),
      Center(
        child: Text("Привет!"),
      ),
      Center(
        child: Text(
            "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас."),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          child: Text("ДАЛЬШЕ"),
          onPressed: () {},
        ),
      )
    ]));
    //
  }
}
