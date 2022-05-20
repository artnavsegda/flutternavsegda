import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';

class SetPage extends StatelessWidget {
  const SetPage({Key? key, required this.modifiers}) : super(key: key);

  final List<GraphModifier> modifiers;

  @override
  Widget build(BuildContext context) {
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
      body: Stepper(steps: [
        ...modifiers.map((modifier) => Step(
              title: Text(modifier.caption ?? 'Выберите'),
              content: Text('Content for Step'),
            )),
      ]),
    );
  }
}
