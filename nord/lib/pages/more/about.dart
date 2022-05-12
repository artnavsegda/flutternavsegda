import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
        title: const Text('О приложении'),
      ),
      body: Column(
        children: [
          Image.asset('assets/Illustration-Logo.png'),
          Text(
            'Разработано с любовью в компании CyberiaSoft',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
              'Пишите нам — будем рады услышать все ваши пожелания и предложения'),
          ElevatedButton(
              onPressed: () {}, child: Text('Написать разработчикам')),
          Spacer(),
          Text('Версия 2.10.1 (29143)'),
        ],
      ),
    );
  }
}
