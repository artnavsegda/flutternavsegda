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
                GraphAuthResult nordAuthResult =
                    GraphAuthResult.fromJson(resultData['authenticate']);
                Provider.of<LoginState>(context, listen: false).token =
                    nordAuthResult.token;
                context.go('/welcome');
              },
            ),
            builder: (runMutation, result) {
              Future.delayed(const Duration(seconds: 5), () {
                GraphDevice nordGraphDevice = GraphDevice(
                    bundleID: "com.levrana", gUID: 'test', oSType: "IOS");
                runMutation(nordGraphDevice.toJson());
              });
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
