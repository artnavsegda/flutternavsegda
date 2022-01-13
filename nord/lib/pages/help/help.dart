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
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpTopicPage(),
                ),
              )
            },
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

class HelpTopicPage extends StatelessWidget {
  const HelpTopicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Бонусная программа'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset('assets/Icon-West.png')),
        ),
        body: ListView(
          children: [
            ExpansionTile(
              title: Text('Термины и определения'),
              children: [],
            ),
            ExpansionTile(
              title: Text('Общие положения'),
              children: [],
            ),
            ExpansionTile(
              title: Text('Как копить и тратить бонусы'),
              children: [
                Text(
                    '''5% от каждой покупки на бонусный счёт и оплачивайте до 20% от покупок бонусными рублями.
При оплате покупки сообщите сотруднику кондитерской о наличии бонусной карты и вашем желании начислить или списать бонусные рубли.
Отсканируйте QR-код или назовите цифровой код из мобильного приложения. В том случае, если у вас не установлено мобильное приложение, назовите свой номер телефона.
Бонусная программа действительна только в мобильном приложении или по номеру телефона в наших кафе-кондитерских.''')
              ],
            ),
          ],
        ));
  }
}
