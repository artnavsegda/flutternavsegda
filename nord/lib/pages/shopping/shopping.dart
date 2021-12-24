import 'package:flutter/material.dart';
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
