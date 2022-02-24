import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/login_state.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
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
        child: ListView(children: [
          Text('Бедржих,\nрады видеть вас снова',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 9),
          Text(
              'Для входа используйте ваш пароль.\nЕсли забыли его, мы пришлем вам новый.'),
          const SizedBox(height: 24),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Пароль",
            ),
          ),
          Mutation(
            options: MutationOptions(
                document: gql(checkClient),
                onError: (error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Ошибка'),
                      content: Text(error!.graphqlErrors[0].message),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
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
                }),
            builder: (runMutation, result) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                    child: const Text("Войти"),
                    onPressed: () {
                      runMutation(
                        GraphCheckUser(
                          code: passwordController.text,
                          step: 'PASSWORD',
                        ).toJson(),
                      );
                    }),
              );
            },
          ),
          const SizedBox(height: 8),
          Mutation(
              options: MutationOptions(
                document: gql(forgotPassword),
                onCompleted: (dynamic resultData) async {},
              ),
              builder: (
                RunMutation runMutation,
                QueryResult? result,
              ) {
                return TextButton(
                    onPressed: () {
                      runMutation({});
                    },
                    child: const Text('Сбросить пароль'));
              }),
        ]),
      ),
    );
  }
}
