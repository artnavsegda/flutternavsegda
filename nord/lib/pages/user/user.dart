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
          title: const Text("Princess\nBean"),
          trailing: Image.asset('assets/Icon-Edit.png'),
        ),
        Container(
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
            child: AspectRatio(
              aspectRatio: 16 / 9,
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
                    style: const TextStyle(
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
                                return GiftBonusModalSheet();
                              },
                            );
                          },
                          child: const Text('Подарить бонусы'))
                    ],
                  )
                ],
              ),
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
