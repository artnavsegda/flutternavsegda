import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'catalog.dart';

const String authenticate = r'''
mutation authenticate($gUID: String!, $bundleID: String!, $oSType: graphOSTypeEnum!) {
  authenticate(device: {gUID: $gUID, bundleID: $bundleID, oSType: $oSType}) 
  {
    token
  }
}
''';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      image: AssetImage('assets/Приветствие@2x.png'),
      title: "Привет!",
      body:
          "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас.",
      child: Mutation(
        options: MutationOptions(
          document: gql(authenticate),
          onCompleted: (dynamic resultData) {
            print(resultData);
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ))),
            child: Text("ДАЛЬШЕ"),
            onPressed: () {
              runMutation({
                'gUID': "hello",
                'bundleID': "ru.levrana.mobile",
                'oSType': "IOS",
              });

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          );
        },
      ),
    );
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
        child: Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ))),
              child: Text("РАЗРЕШИТЬ"),
              onPressed: () {},
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Text("ПОЗЖЕ")),
          ],
        ));
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isAgreed = false;
  bool isFamiliarized = false;
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      image: AssetImage('assets/Включить оповещения@2x.png'),
      title: "Войти",
      body:
          "В личном кабинете можно будет составлять списки покупок, контролировать счет и тратить бонусы.",
      child: Row(
        children: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ))),
            child: Text("РАЗРЕШИТЬ"),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: const Radius.circular(16.0)),
                ),
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    var maskFormatter = new MaskTextInputFormatter(
                        mask: '+7 (###) ###-##-##',
                        filter: {"#": RegExp(r'[0-9]')});
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Wrap(
                          children: [
                            Text("Вход",
                                style: GoogleFonts.montserrat(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                )),
                            TextField(
                              controller: textController,
                              inputFormatters: [maskFormatter],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '+7(___) ___-__-__'),
                            ),
                            CheckboxListTile(
                              title: Text(
                                  "Ознакомлен с условиями положения о защите персональных данных"),
                              value: isFamiliarized,
                              onChanged: (newValue) => setModalState(() {
                                isFamiliarized = newValue!;
                              }),
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            CheckboxListTile(
                              title: Text(
                                  "Даю свое согласие на обработку персональных данных"),
                              value: isAgreed,
                              onChanged: (newValue) => setModalState(() {
                                isAgreed = newValue!;
                              }),
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            ElevatedButton(
                                onPressed: isAgreed && isFamiliarized
                                    ? () {
                                        print(textController.text);
                                      }
                                    : null,
                                child: Text("ВОЙТИ")),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text("ПОЗЖЕ")),
        ],
      ),
    );
  }
}

class Dialog extends StatelessWidget {
  const Dialog(
      {Key? key,
      required this.image,
      required this.title,
      required this.body,
      required this.child})
      : super(key: key);

  final ImageProvider image;
  final String title;
  final String body;
  final Widget child;

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
            child
          ],
        ),
      ),
    ]));
    //
  }
}
