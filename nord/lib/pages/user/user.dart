import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {},
          title: const Text("Princess Bean"),
          trailing: Image.asset('assets/Icon Edit.png'),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Подарки"),
          leading: Image.asset('assets/Icon Present.png'),
        ),
        ListTile(
          onTap: () {},
          title: const Text("История заказов"),
          leading: Image.asset('assets/Icon History.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Адреса доставки"),
          leading: Image.asset('assets/Icon Place.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Смена пароля"),
          leading: Image.asset('assets/Icon Lock.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Выход из приложения"),
          leading: Image.asset('assets/Icon Logout.png'),
        ),
      ],
    );
  }
}
