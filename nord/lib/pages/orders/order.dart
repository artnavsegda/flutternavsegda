import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Заказ №2564848'),
        ),
        body: ListView(
          children: [
            Row(
              children: [
                Text('Оценка заказа'),
              ],
            ),
            Text('Детали заказа'),
            ListTile(
              subtitle: Text('Доставка по адресу'),
              title:
                  Text('Санкт-Петербург, Дачный проспект, 36к3, квартира 410'),
            ),
            ListTile(
              subtitle: Text('Дата и время доставки'),
              title: Text('22 сентября, с 11:00 до 13:00'),
            ),
            ListTile(
              subtitle: Text('Получатель'),
              title: Text('Антон Горький, +7 (999) 102-17-32'),
            ),
            Text('Детали оплаты'),
            Row(
              children: [Text('Оплачено'), Text('1 325 ₽')],
            ),
            Divider(),
            Row(
              children: [Text('Сумма заказа'), Text('10 325 ₽')],
            ),
            Row(
              children: [Text('Доставка'), Text('Бесплатно')],
            ),
            Row(
              children: [Text('Скидка'), Text('90 ₽')],
            ),
            Row(
              children: [Text('Оплачено баллами'), Text('10 000 Б')],
            ),
            ListTile(
              title: Text('Чек оплаты'),
              trailing: Image.asset('assets/Icon-Site.png'),
            ),
            Text('Состав заказа'),
            OrderCartTile(),
            OrderCartTile(),
            OrderCartTile(),
            OrderCartTile(),
          ],
        ));
  }
}

class OrderCartTile extends StatelessWidget {
  const OrderCartTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/placeholder/product10/Illustration.png'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Чай каркаде с\nапельсином',
                            style: TextStyle(fontSize: 16)),
                        const Text('450 мл',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('836 ₽', style: TextStyle(fontSize: 16)),
                        const Text('X 1', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
