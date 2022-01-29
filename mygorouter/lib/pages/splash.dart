import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';
import '../gql.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Mutation(
            options: MutationOptions(
              document: gql(authenticate),
              onError: (error) {
                print("ERROR");
                print(error);
              },
              onCompleted: (dynamic resultData) {
                print(resultData);
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['authenticate']['token'];
                context.go('/welcome');
              },
            ),
            builder: (runMutation, result) {
              Future.delayed(const Duration(seconds: 5), () {
                runMutation({
                  //'gUID': data.identifierForVendor,
                  'gUID': 'test',
                  'bundleID': "ru.severmetropol.mobile",
                  'oSType': "IOS",
                });
              });
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
