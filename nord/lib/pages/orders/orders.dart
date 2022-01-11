import 'package:flutter/material.dart';
import 'order.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История заказов'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('18 апреля'),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderPage(),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Доставлен'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Заказ №2564848 от 21:40'), Text('1020 ₽')],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Дачный проспект, 36к3, кв. 218'),
                    Text('+500 Б')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
