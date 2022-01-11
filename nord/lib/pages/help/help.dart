import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Справка'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Бонусная программа'),
            trailing: Image.asset('assets/Icon-East.png'),
          ),
          ListTile(
            title: Text('Доставка и оплата'),
            trailing: Image.asset('assets/Icon-East.png'),
          ),
          ListTile(
            title: Text('О компании'),
            trailing: Image.asset('assets/Icon-East.png'),
          ),
          ListTile(
            title: Text('Оптовые продажи'),
            trailing: Image.asset('assets/Icon-East.png'),
          ),
          ListTile(
            title: Text('О компании'),
            trailing: Image.asset('assets/Icon-East.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                '''Для улучшения работы приложения компания может использовать статистические и иные технические данные о действих пользователя при работе с приложением (перемещение между экранами, нажатие кнопок и т.д.). Персональная данные или любая финансовая информация не используется для данных целей.

Основные положения сбора и хранения информации вы можете найти в Положении об Обработке и защите персональных данных.'''),
          )
        ],
      ),
    );
  }
}
