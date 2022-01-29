import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../login_state.dart';
import '../gql.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneNumberController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Mutation(
          options: MutationOptions(
            document: gql(loginClient),
            onError: (error) {
              print("ERROR");
              print(error);
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Ошибка'),
                  content: const Text('AlertDialog description'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            onCompleted: (resultData) {
              GraphClientResult nordClientResult =
                  GraphClientResult.fromJson(resultData['loginClient']);
              if (nordClientResult.result == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    nordClientResult.token ?? '';

                if (nordClientResult.nextStep == 'PASSWORD')
                  context.push('/password');
                else
                  context.push('/sms');
              } else {
                print(resultData);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Ошибка'),
                    content: Text('${nordClientResult.errorMessage}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          builder: (runMutation, result) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: phoneNumberController),
                  ElevatedButton(
                      onPressed: () {
                        runMutation({
                          'clientPhone': int.parse(phoneNumberController.text)
                        });
                        print(phoneNumberController.text);
                      },
                      child: Text('Login')),
                ],
              ),
            );
          }),
    );
  }
}

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordInputController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Mutation(
          options: MutationOptions(
            document: gql(checkClient),
            onError: (error) {
              print("ERROR");
              print(error);
            },
            onCompleted: (dynamic resultData) {
              if (resultData['checkClient']['result'] == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['checkClient']['token'];
                Provider.of<LoginState>(context, listen: false).loggedIn = true;
                context.go('/main');
              }
            },
          ),
          builder: (runMutation, result) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: passwordInputController),
                ElevatedButton(
                    onPressed: () {
                      runMutation({
                        'code': passwordInputController.text,
                        'step': 'PASSWORD',
                      });
                      print(passwordInputController.text);
                    },
                    child: Text('Password'))
              ],
            );
          }),
    );
  }
}

class ConfirmSMSPage extends StatelessWidget {
  const ConfirmSMSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController smsInputController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Mutation(
          options: MutationOptions(
            document: gql(checkClient),
            onError: (error) {
              print("ERROR");
              print(error);
            },
            onCompleted: (dynamic resultData) {
              if (resultData['checkClient']['result'] == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['checkClient']['token'];
                Provider.of<LoginState>(context, listen: false).loggedIn = true;
                context.go('/main');
              }
            },
          ),
          builder: (runMutation, result) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: smsInputController),
                ElevatedButton(
                    onPressed: () {
                      runMutation({
                        'code': smsInputController.text,
                        'step': 'SMS_CONFIRMED_PHONE',
                      });
                      print(smsInputController.text);
                    },
                    child: Text('SMS'))
              ],
            );
          }),
    );
  }
}
