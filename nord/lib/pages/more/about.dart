import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 32),
            Image.asset('assets/Illustration-Logo.png'),
            SizedBox(height: 84),
            Text(
              'Разработано с любовью в компании CyberiaSoft',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
                'Пишите нам — будем рады услышать все ваши пожелания и предложения'),
            SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {
                  launch('mailto:writeme@cyberiasoft.com');
                },
                child: Text('Написать разработчикам')),
            Spacer(),
            Center(child: Text('Версия 2.10.1 (29143)')),
          ],
        ),
      ),
    );
  }
}
