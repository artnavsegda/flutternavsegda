import 'package:flutter/material.dart';
import 'edit_user.dart';
import '../onboarding/onboarding.dart';
import '../orders/orders.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditUser()));
          },
          title: const Text("Princess Bean"),
          trailing: Image.asset('assets/Icon-Edit.png'),
        ),
        Container(
            child: Column(
          children: [
            Text('У вас'),
            Text('95 бонусов'),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {}, child: const Text('Позвать друга')),
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return GiftBonusModalSheet();
                        },
                      );
                    },
                    child: const Text('Подарить бонусы'))
              ],
            )
          ],
        )),
        ListTile(
          onTap: () {},
          title: const Text("Подарки"),
          leading: Image.asset('assets/Icon-Present.png'),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Промокод"),
          leading: Image.asset('assets/Icon-Redeem-Card.png'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrdersPage()));
          },
          title: const Text("История заказов"),
          leading: Image.asset('assets/Icon-History.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Адреса доставки"),
          leading: Image.asset('assets/Icon-Place.png'),
        ),
        Divider(),
        ListTile(
          onTap: () async {},
          title: const Text("Смена пароля"),
          leading: Image.asset('assets/Icon-Lock.png'),
        ),
        ListTile(
          onTap: () async {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Onboarding()));
          },
          title: const Text("Выход из приложения"),
          leading: Image.asset('assets/Icon-Logout.png'),
        ),
      ],
    );
  }
}

class GiftBonusModalSheet extends StatelessWidget {
  const GiftBonusModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Подарочные бонусы'),
        TextField(),
        Slider(
          onChanged: (newVal) {},
          value: 0,
        ),
        Text('Вы можете подарить до 120 бонусов'),
        TextField(),
        ElevatedButton(onPressed: () {}, child: Text('Подарить бонусы'))
      ],
    );
  }
}
