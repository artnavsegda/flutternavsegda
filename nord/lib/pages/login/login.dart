import 'package:flutter/material.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-Close.png')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Войти или\nзарегистрироваться',
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
            SizedBox(height: 9),
            Text('Мы отправим на номер SMS-сообщение с кодом потверждения'),
            SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Номер телефона", hintText: '+7 (___) ___-__-__'),
            ),
            SizedBox(height: 32),
            NordCheckboxTile(
                title: Text(
              'Ознакомлен с условиями положения о защите персональных данных',
              style: TextStyle(fontSize: 16),
            )),
            SizedBox(height: 32),
            NordCheckboxTile(
                title: Text(
                    'Даю свое согласие на обработку персональных данных',
                    style: TextStyle(fontSize: 16))),
            SizedBox(height: 32),
            ElevatedButton(onPressed: () {}, child: Text('Далее')),
            SizedBox(height: 32),
            ListTile(
              title: Text('Политика конфиденциальности'),
              trailing: Image.asset('assets/Icon-Navigate-Next.png'),
            ),
            ListTile(
              title: Text('Правила бонусной программы'),
              trailing: Image.asset('assets/Icon-Navigate-Next.png'),
            ),
          ],
        ),
      ),
    );
  }
}
