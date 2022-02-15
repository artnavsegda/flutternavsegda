import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'order.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
        title: const Text('История заказов'),
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              '18 апреля',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Color(0xFF9CA4AC)),
            ),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          )
        ],
      ),
    );
  }
}
