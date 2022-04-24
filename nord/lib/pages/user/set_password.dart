import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../gql.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _isPassValid = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    void handleChange() {
      if (passwordController.text.isNotEmpty) {
        setState(() {
          _isPassValid = passwordController.text == confirmController.text;
        });
      }
    }

    passwordController.addListener(handleChange);
    confirmController.addListener(handleChange);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          runSpacing: 8.0,
          children: [
            const Text(
              'Смена пароля',
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Введите пароль",
              ),
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Подтвердите пароль",
              ),
            ),
            Mutation(
                options: MutationOptions(
                  document: gql(setPassword),
                  onCompleted: (resultData) {
                    Navigator.pop(context);
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('УСТАНОВИТЬ ПАРОЛЬ'),
                    onPressed: _isPassValid
                        ? () =>
                            runMutation({'password': passwordController.text})
                        : null,
                  );
                })
          ],
        ),
      ),
    );
  }
}
