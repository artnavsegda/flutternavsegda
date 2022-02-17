import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../components/components.dart';
import '../../gql.dart';
import '../../login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '+7 (###) ###-##-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_Close,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Войти или\nзарегистрироваться',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 9),
                const Text(
                    'Мы отправим на номер SMS-сообщение с кодом потверждения'),
                const SizedBox(height: 24),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          maskFormatter.clear();
                        },
                        icon: Icon(
                          SeverMetropol.Icon_Clear,
                          size: 24.0,
                        ),
                      ),
                      labelText: "Номер телефона",
                      hintText: '+7 (___) ___-__-__'),
                ),
                const SizedBox(height: 32),
                const NordCheckboxTile(
                    title: Text(
                  'Ознакомлен с условиями положения о защите персональных данных',
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(height: 32),
                const NordCheckboxTile(
                    title: Text(
                        'Даю свое согласие на обработку персональных данных',
                        style: TextStyle(fontSize: 16))),
                const SizedBox(height: 32),
                Mutation(
                    options: MutationOptions(
                      document: gql(loginClient),
                      onError: (error) {
                        print("ERROR");
                        print(error);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Ошибка'),
                            content: SingleChildScrollView(
                                child: Text(
                              '$error',
                              style: TextStyle(fontSize: 10),
                            )),
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
                        print(resultData);
                        if (resultData != null) {
                          GraphClientResult nordClientResult =
                              GraphClientResult.fromJson(
                                  resultData['loginClient']);
                          if (nordClientResult.result == 0) {
                            Provider.of<LoginState>(context, listen: false)
                                .token = nordClientResult.token ?? '';

                            if (nordClientResult.nextStep == 'PASSWORD')
                              context.push('/password');
                            else
                              context.pushNamed('sms', params: {
                                'phone': maskFormatter.getMaskedText()
                              });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Ошибка'),
                                content:
                                    Text('${nordClientResult.errorMessage}'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                    builder: (runMutation, result) {
                      return ElevatedButton(
                          onPressed: () {
                            runMutation({
                              'clientPhone': int.parse(
                                  '7' + maskFormatter.getUnmaskedText())
                            });
                          },
                          child: Text('Далее'));
                    }),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Политика конфиденциальности',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            trailing: Icon(
              SeverMetropol.Icon_Navigate_Next,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            title: Text(
              'Правила бонусной программы',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            trailing: Icon(
              SeverMetropol.Icon_Navigate_Next,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
