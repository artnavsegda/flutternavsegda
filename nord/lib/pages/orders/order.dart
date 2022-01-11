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
          ],
        ));
  }
}
