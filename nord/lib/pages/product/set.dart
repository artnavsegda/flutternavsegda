import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';

class SetPage extends StatelessWidget {
  const SetPage({Key? key}) : super(key: key);

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
      body: Stepper(steps: []),
    );
  }
}
