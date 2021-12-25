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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          Text('Чай каркаде с\nапельсином',
                              style: TextStyle(fontSize: 16)),
                          Text('450 мл', style: TextStyle(color: Colors.grey)),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Image.asset('assets/Icon-Remove.png'),
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(24.0, 24.0)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0.0))),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 32,
                                height: 24,
                                child: Text('2'),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Image.asset('assets/Icon-Add.png'),
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(24.0, 24.0)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0.0))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('836 ₽', style: TextStyle(fontSize: 16)),
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
