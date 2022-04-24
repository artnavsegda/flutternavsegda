import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nord/sever_metropol_icons.dart';
import '../../components/components.dart';
import '../../gql.dart';
import '../../login_state.dart';
import '../../utils.dart';
import '../../login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAgreed = false;
  bool isFamiliarized = false;
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
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
                NordCheckboxTile(
                    value: isFamiliarized,
                    onChanged: (newValue) => setState(() {
                          isFamiliarized = newValue!;
                        }),
                    title: Text(
                      'Ознакомлен с условиями положения о защите персональных данных',
                      style: TextStyle(fontSize: 16),
                    )),
                const SizedBox(height: 32),
                NordCheckboxTile(
                    value: isAgreed,
                    onChanged: (newValue) => setState(() {
                          isAgreed = newValue!;
                        }),
                    title: Text(
                        'Даю свое согласие на обработку персональных данных',
                        style: TextStyle(fontSize: 16))),
                const SizedBox(height: 32),
                Mutation(
                    options: MutationOptions(
                      document: gql(loginClient),
                      onError: (error) {
                        showErrorAlert(context, '$error');
                      },
                      onCompleted: (resultData) {
                        if (resultData != null) {
                          GraphClientResult nordClientResult =
                              GraphClientResult.fromJson(
                                  resultData['loginClient']);
                          if (nordClientResult.result == 0) {
                            context.read<LoginState>().token =
                                nordClientResult.token ?? '';

                            if (nordClientResult.nextStep == 'PASSWORD')
                              context.push('/password');
                            else
                              context.pushNamed('sms', params: {
                                'phone': maskFormatter.getMaskedText()
                              });
                          } else {
                            showErrorAlert(
                                context, nordClientResult.errorMessage ?? '');
                          }
                        }
                      },
                    ),
                    builder: (runMutation, result) {
                      return ElevatedButton(
                          onPressed: isAgreed && isFamiliarized
                              ? () {
                                  print('phone: ' +
                                      maskFormatter.getUnmaskedText());
                                  runMutation({
                                    'clientPhone': int.parse(
                                        '7' + maskFormatter.getUnmaskedText())
                                  });
                                }
                              : null,
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
            onTap: () async {
              String privacyPolicyUrl =
                  context.read<LoginState>().settings?.privacyPolicy ??
                      'https://natribu.org';
              if (await canLaunch(privacyPolicyUrl)) {
                await launch(privacyPolicyUrl);
              } else {
                showErrorAlert(
                    context, 'Не знаю как открыть $privacyPolicyUrl');
              }
            },
          ),
          ListTile(
            onTap: (() {}),
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
