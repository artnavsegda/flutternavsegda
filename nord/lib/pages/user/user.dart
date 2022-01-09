import 'package:flutter/material.dart';
import 'edit_user.dart';
import '../../sever_metropol_icons.dart';
import '../onboarding/onboarding.dart';
import '../orders/orders.dart';
import '../address/delivery_address.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            foregroundImage: AssetImage('assets/treska.jpg'),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditUser()));
          },
          title: const Text("Princess\nBean"),
          trailing: Icon(SeverMetropol.Icon_Edit, color: Colors.red.shade900),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
                      blurRadius: 20.0,
                      offset: Offset(0.0, 6.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[Color(0xffCD0643), Color(0xffB0063A)])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'У вас',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Text(
                    '120 бонусов',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Forum',
                      fontSize: 24.0,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text('Позвать друга')),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return const GiftBonusModalSheet();
                              },
                            );
                          },
                          child: const Text('Подарить бонусы'))
                    ],
                  )
                ],
              )),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Подарки"),
          leading: Icon(SeverMetropol.Icon_Present, color: Colors.red.shade900),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Промокод"),
          leading:
              Icon(SeverMetropol.Icon_Redeem_Card, color: Colors.red.shade900),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrdersPage()));
          },
          title: const Text("История заказов"),
          leading: Icon(SeverMetropol.Icon_History, color: Colors.red.shade900),
        ),
        ListTile(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeliveryAddressPage()));
          },
          title: const Text("Адреса доставки"),
          leading: Icon(SeverMetropol.Icon_Place, color: Colors.red.shade900),
        ),
        const Divider(
          color: Color(0xFFEFF3F4),
          thickness: 2,
          indent: 16,
          endIndent: 16,
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Смена пароля"),
          leading: Icon(SeverMetropol.Icon_Lock, color: Colors.red.shade900),
        ),
        ListTile(
          onTap: () async {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Onboarding()));
          },
          title: const Text("Выход из приложения"),
          leading: Icon(SeverMetropol.Icon_Logout, color: Colors.red.shade900),
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
        const TextField(),
        Slider(
          onChanged: (newVal) {},
          value: 0,
        ),
        const Text('Вы можете подарить до 120 бонусов'),
        const TextField(),
        ElevatedButton(onPressed: () {}, child: const Text('Подарить бонусы'))
      ],
    );
  }
}
