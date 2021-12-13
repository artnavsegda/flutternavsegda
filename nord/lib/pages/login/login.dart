import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Войти или зарегистрироваться'),
          Text('Мы отправим на номер SMS-сообщение с кодом потверждения'),
          TextField(),
          CheckboxListTile(
            value: false,
            onChanged: (newValue) {},
            title: Text(
                'Ознакомлен с условиями положения о защите персональных данных'),
          ),
          CheckboxListTile(
            value: false,
            onChanged: (newValue) {},
            title: Text('Даю свое согласие на обработку персональных данных'),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Далее')),
          ListTile(
            title: Text('Политика конфиденциальности'),
          ),
          ListTile(
            title: Text('Правила бонусной программы'),
          ),
        ],
      ),
    );
  }
}
