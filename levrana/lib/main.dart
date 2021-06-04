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
      Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Привет!",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 150.0,
                  ),
                  child: Text(
                      "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас."),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ))),
              child: Text("ДАЛЬШЕ"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
    ]));
    //
  }
}

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      image: AssetImage('assets/Включить оповещения@2x.png'),
      title: "Будьте на связи",
      body:
          "Разрешите отправлять для вас уведомления, чтобы мы рассказывали о состоянии ваших заказов и проводящихся акциях и скидках",
      confirm: "РАЗРЕШИТЬ",
      cancel: "ПОЗЖЕ",
      onConfirm: () {},
      onCancel: () {},
    );
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      image: AssetImage('assets/Включить оповещения@2x.png'),
      title: "Войти",
      body:
          "В личном кабинете можно будет составлять списки покупок, контролировать счет и тратить бонусы.",
      confirm: "ВОЙТИ",
      cancel: "ПОЗЖЕ",
      onConfirm: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: const Radius.circular(16.0)),
          ),
          builder: (context) {
            // Using Wrap makes the bottom sheet height the height of the content.
            // Otherwise, the height will be half the height of the screen.
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Text("Вход",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      )),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '+7(___) ___-__-__'),
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                  ),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text('Get link'),
                  ),
                ],
              ),
            );
          },
        );
      },
      onCancel: () {},
    );
  }
}

class Dialog extends StatelessWidget {
  const Dialog(
      {Key? key,
      required this.image,
      required this.title,
      required this.body,
      required this.confirm,
      this.cancel = "ПОЗЖЕ",
      required this.onConfirm,
      this.onCancel})
      : super(key: key);

  final ImageProvider image;
  final String title;
  final String body;
  final String confirm;
  final String cancel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image(image: image),
      Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(title,
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 150.0,
                  ),
                  child: Text(body),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ))),
                  child: Text(confirm),
                  onPressed: onConfirm,
                ),
                TextButton(onPressed: () {}, child: Text(cancel)),
              ],
            )
          ],
        ),
      ),
    ]));
    //
  }
}
