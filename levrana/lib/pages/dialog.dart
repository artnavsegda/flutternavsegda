import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../main.dart';
import 'login.dart';

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
    return DialogPage(
      image: AssetImage('assets/Приветствие.png'),
      title: "Привет!",
      body:
          "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас.",
      child: Mutation(
        options: MutationOptions(
          document: gql(authenticate),
          onError: (error) {
            print(error);
          },
          onCompleted: (dynamic resultData) async {
            print(resultData);
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('token', resultData['authenticate']['token']);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
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
            onPressed: () async {
              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
              if (Platform.isAndroid) {
                var build = await deviceInfo.androidInfo;
                runMutation({
                  'gUID': build.androidId,
                  'bundleID': "ru.levrana.mobile",
                  'oSType': "ANDROID",
                });
              } else if (Platform.isIOS) {
                var data = await deviceInfo.iosInfo;
                runMutation({
                  'gUID': data.identifierForVendor,
                  'bundleID': "ru.levrana.mobile",
                  'oSType': "IOS",
                });
              }
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
    return DialogPage(
        image: AssetImage('assets/Включить оповещения.png'),
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

class DialogPage extends StatelessWidget {
  const DialogPage(
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
      Image(
        image: image,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
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
