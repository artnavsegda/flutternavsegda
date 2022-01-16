import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';

const String loginClient = r'''
mutation loginClient($clientPhone: Long!) {
  loginClient(clientPhone: $clientPhone) {
    result
    errorMessage
    clientGUID
    token
    nextStep
  }
}
''';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneNumberController = TextEditingController();
    return Scaffold(
      body: Mutation(
          options: MutationOptions(
            document: gql(loginClient),
            onError: (error) {
              print("ERROR");
              print(error);
            },
            onCompleted: (resultData) {
              print(resultData);
              if (resultData['loginClient']['result'] == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['loginClient']['token'];

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return resultData['loginClient']['nextStep'] == 'PASSWORD'
                        ? const PasswordPage()
                        : const ConfirmSMSPage();
                  },
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
                      child: Text('Login'))
                ],
              ),
            );
          }),
    );
  }
}

const String checkPassword = r'''
mutation checkPassword($password: String!){
  checkClient(checkUser: {step: PASSWORD, code: $password}) {
    result
    errorMessage
    token
  }
}
''';

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordInputController =
        TextEditingController();
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Mutation(
          options: MutationOptions(
            document: gql(checkPassword),
            onError: (error) {
              print("ERROR");
              print(error);
            },
            onCompleted: (dynamic resultData) {
              if (resultData['checkClient']['result'] == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['checkClient']['token'];
                Provider.of<LoginState>(context, listen: false).loggedIn = true;
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
                      runMutation({'password': passwordInputController.text});
                      print(passwordInputController.text);
                    },
                    child: Text('Password'))
              ],
            );
          }),
    );
  }
}

const String checkSms = r'''
mutation checkClient($code: String!){
  checkClient(checkUser: {step: SMS_CONFIRMED_PHONE, code: $code}) {
    result
    errorMessage
    token
  }
}
''';

class ConfirmSMSPage extends StatelessWidget {
  const ConfirmSMSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController smsInputController = TextEditingController();
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Mutation(
          options: MutationOptions(
            document: gql(checkSms),
            onError: (error) {
              print("ERROR");
              print(error);
            },
            onCompleted: (dynamic resultData) {
              if (resultData['checkClient']['result'] == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['checkClient']['token'];
                Provider.of<LoginState>(context, listen: false).loggedIn = true;
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
                      runMutation({'code': smsInputController.text});
                      print(smsInputController.text);
                    },
                    child: Text('SMS'))
              ],
            );
          }),
    );
  }
}
