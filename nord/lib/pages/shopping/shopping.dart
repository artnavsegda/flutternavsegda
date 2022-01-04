import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../components/select_address_bottom_sheet.dart';
import '../../components/components.dart';
import 'cart_is_empty.dart';
import 'registration.dart';

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
          Expanded(
            child: ListView(
              children: [
                CartTile(),
                CartTile(),
                CartTile(),
                CartTile(),
                CartTile(),
                CartTile(),
                CartTile(),
                CartTile(),
                CartTile(),
                TextField(),
                Text('Сумма заказа'),
                TextField(),
                Text('Сумма заказа'),
                Text('Доставка'),
                Text('Скидка'),
                Divider(),
                Text('Общая сумма заказа'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()));
                },
                child: Text('Оформить заказ'))
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
        padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
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
                                  style: TextButton.styleFrom(
                                      minimumSize: const Size(24.0, 24.0),
                                      padding: EdgeInsets.all(0.0)),
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
                                  style: TextButton.styleFrom(
                                      minimumSize: const Size(24.0, 24.0),
                                      padding: EdgeInsets.all(0.0)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('836 ₽', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 13),
                  Divider(
                    height: 1,
                  ),
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
