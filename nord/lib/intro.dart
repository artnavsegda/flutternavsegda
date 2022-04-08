import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'gql.dart';
import 'login_state.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
          options: MutationOptions(
            document: gql(authenticate),
            onError: (error) {
              print("ERROR");
              print(error);
            },
            onCompleted: (dynamic resultData) {
              GraphAuthResult nordAuthResult =
                  GraphAuthResult.fromJson(resultData['authenticate']);
              Provider.of<LoginState>(context, listen: false).token =
                  nordAuthResult.token;
              context.go('/welcome');
            },
          ),
          builder: (runMutation, result) {
            Future.delayed(const Duration(seconds: 5), () async {
              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
              //String? fcmToken = await FirebaseMessaging.instance.getToken();

              if (Platform.isAndroid) {
                var build = await deviceInfo.androidInfo;
                GraphDevice levranaGraphDevice = GraphDevice(
                  bundleID: "com.severmetropol",
                  gUID: build.androidId ?? "",
                  oSType: "ANDROID",
                  //pushNotificationToken: fcmToken,
                );
                runMutation(levranaGraphDevice.toJson());
              } else if (Platform.isIOS) {
                var data = await deviceInfo.iosInfo;
                GraphDevice nordGraphDevice = GraphDevice(
                  bundleID: "ru.premiumbonus.severmetropol",
                  gUID: data.identifierForVendor ?? "",
                  oSType: "IOS",
                  //pushNotificationToken: fcmToken,
                );
                runMutation(nordGraphDevice.toJson());
              }
            });
            return Stack(
              children: [
                RiveAnimation.asset(
                  'assets/sever.riv',
                  fit: BoxFit.cover,
                ),
                Positioned(
                    bottom: 48,
                    left: 32,
                    right: 32,
                    child: Text(
                      'Легендарные, любимые, особенные.\nТеперь всегда под рукой!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white),
                    ))
              ],
            );
          }),
    );
  }
}
