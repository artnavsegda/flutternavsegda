import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:levrana/pages/login/login.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../gql.dart';
import 'dialog.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogPage(
      image: AssetImage('assets/Welcome.png'),
      title: "Привет!",
      body:
          "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас.",
      child: Consumer<AppModel>(builder: (context, model, child) {
        return Mutation(
          options: MutationOptions(
            document: gql(authenticate),
            onError: (error) {
              print(error);
            },
            onCompleted: (dynamic resultData) async {
              print(resultData);
              await model.setToken(resultData['authenticate']['token']);
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
        );
      }),
    );
  }
}
