import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../components/select_address_bottom_sheet.dart';
import 'cart_is_empty.dart';
import '../../components/components.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return CartIsEmpty();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [TextButton(onPressed: () {}, child: Text('Очистить'))],
      ),
      body: Column(
        children: [
          const AddressTile2(),
          Slidable(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/placeholder/product10/Illustration.png'),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Чай каркаде с\nапельсином'),
                      Text('450 мл'),
                      Text('2'),
                    ],
                  ),
                  Spacer(),
                  Text('836 ₽'),
                ],
              ),
            ),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Colors.red.shade900,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Итого'),
                  Text('1 325 ₽'),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Оформить заказ'))
          ],
        ),
      ),
    );
  }
}
