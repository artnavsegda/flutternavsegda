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
            onCompleted: (dynamic resultData) {
              if (resultData['loginClient']['result'] == 0) {
                Provider.of<LoginState>(context, listen: false).token =
                    resultData['loginClient']['token'];

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const PasswordPage();
                  },
                );

                if (resultData['loginClient']['nextStep'] == 'PASSWORD') {
                  _enterPassword(context);
                } else {
                  _confirmSMS(context);
                }
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
                        print(phoneNumberController.text);
                      },
                      child: Text('Enter'))
                ],
              ),
            );
          }),
    );
  }
}
