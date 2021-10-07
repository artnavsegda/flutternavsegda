import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../main.dart';
import '../../gql.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogPage(
      image: AssetImage('assets/Welcome.png'),
      title: "Привет!",
      body:
          "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас.",
      child: Mutation(
        options: MutationOptions(
          document: gql(authenticate),
          onError: (error) {
            //print(error);
          },
          onCompleted: (dynamic resultData) async {
            //print(resultData);
            final prefs = await SharedPreferences.getInstance();
            //print("authenticate token:" + resultData['authenticate']['token']);
            prefs.setString('token', resultData['authenticate']['token']);
            Navigator.pushReplacement(
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
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text("ДАЛЬШЕ"),
            onPressed: () async {
              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
              if (Platform.isAndroid) {
                var build = await deviceInfo.androidInfo;
                runMutation({
                  'gUID': build.androidId,
                  'bundleID': "com.levrana",
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

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogPage(
      image: AssetImage('assets/Login.png'),
      title: "Войти",
      body:
          "В личном кабинете можно будет составлять списки покупок, контролировать счет и тратить бонусы.",
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text("ВОЙТИ"),
              onPressed: () => _userLogin(context),
            ),
          ),
          TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(110, 48),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text("ПОЗЖЕ")),
        ],
      ),
    );
  }

  void _userLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(16.0)),
      ),
      builder: (context) {
        return UserLoginPage();
      },
    );
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
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
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