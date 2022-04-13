import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../login_state.dart';
import '../../utils.dart';
import 'package:nord/gql.dart';

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
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Введите\nкод подтверждения',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 9),
            Text('Код подтверждения был отправлен на номер:\n$phone'),
            const SizedBox(height: 24),
            TextField(
              controller: smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Код подтверждения",
                  suffixIcon: IconButton(
                    onPressed: () {
                      smsCodeController.clear();
                    },
                    icon: Icon(
                      SeverMetropol.Icon_Clear,
                      size: 24.0,
                    ),
                  )),
            ),
            const SizedBox(height: 16),
            Mutation(
                options: MutationOptions(
                  document: gql(checkClient),
                  onError: (error) {
                    showErrorAlert(context, '$error');
                  },
                  onCompleted: (dynamic resultData) {
                    GraphClientResult nordClientResult =
                        GraphClientResult.fromJson(resultData['checkClient']);
                    if (nordClientResult.result == 0) {
                      context.read<LoginState>().token =
                          nordClientResult.token ?? '';
                      context.read<LoginState>().loggedIn = true;
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
