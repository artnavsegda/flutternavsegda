import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../login_state.dart';
import '../../gql.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({Key? key, this.phone}) : super(key: key);

  final String? phone;

  @override
  Widget build(BuildContext context) {
    TextEditingController smsCodeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Введите\nкод подтверждения',
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
            const SizedBox(height: 9),
            Text('Код подтверждения был отправлен на номер:\n$phone'),
            const SizedBox(height: 24),
            TextField(
              controller: smsCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Код подтверждения"),
            ),
            const SizedBox(height: 16),
            Mutation(
                options: MutationOptions(
                  document: gql(checkClient),
                  onError: (error) {
                    print("ERROR");
                    print(error);
                  },
                  onCompleted: (dynamic resultData) {
                    GraphClientResult nordClientResult =
                        GraphClientResult.fromJson(resultData['checkClient']);
                    if (nordClientResult.result == 0) {
                      Provider.of<LoginState>(context, listen: false).token =
                          nordClientResult.token ?? '';
                      Provider.of<LoginState>(context, listen: false).loggedIn =
                          true;
                      context.go('/main');
                    } else {
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
                  return ElevatedButton(
                      onPressed: () {
                        runMutation({
                          'code': smsCodeController.text,
                          'step': 'SMS_CONFIRMED_PHONE',
                        });
                      },
                      child: const Text('Подтвердить'));
                }),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () {}, child: const Text('Запросить новый код')),
          ],
        ),
      ),
    );
  }
}
