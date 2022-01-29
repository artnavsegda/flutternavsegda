import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../components/components.dart';
import 'sms.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '+7 (###) ###-##-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-Close.png')),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Войти или\nзарегистрироваться',
                    style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
                const SizedBox(height: 9),
                const Text(
                    'Мы отправим на номер SMS-сообщение с кодом потверждения'),
                const SizedBox(height: 24),
                TextField(
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
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
                ElevatedButton(
                    onPressed: () {
                      print(maskFormatter.getUnmaskedText());
/*                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SmsPage())); */
                    },
                    child: const Text('Далее')),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Политика конфиденциальности',
              style: TextStyle(color: Colors.red.shade900),
            ),
            trailing: Image.asset('assets/Icon-Navigate-Next.png'),
          ),
          ListTile(
            title: Text(
              'Правила бонусной программы',
              style: TextStyle(color: Colors.red.shade900),
            ),
            trailing: Image.asset('assets/Icon-Navigate-Next.png'),
          ),
        ],
      ),
    );
  }
}
