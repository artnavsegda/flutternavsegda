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
          CartTile(),
          CartTile(),
          CartTile(),
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

class CartTile extends StatelessWidget {
  const CartTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/placeholder/product10/Illustration.png'),
            SizedBox(width: 12),
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
                          Text('Чай каркаде с\nапельсином'),
                          Text('450 мл'),
                          Row(
                            children: [
                              TextButton(onPressed: () {}, child: Text('-')),
                              Text('2'),
                              TextButton(onPressed: () {}, child: Text('+')),
                            ],
                          ),
                        ],
                      ),
                      Text('836 ₽'),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
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
    );
  }
}
