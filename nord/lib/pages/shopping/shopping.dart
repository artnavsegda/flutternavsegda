import 'package:flutter/material.dart';
import '../../components/select_address_bottom_sheet.dart';
import 'cart_is_empty.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [ElevatedButton(onPressed: () {}, child: Text('Очистить'))],
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const SelectAddressBottomSheet();
                },
              );
            },
            leading:
                Image.asset('assets/Illustration-Colored-Delivery-Options.png'),
            title: const Text("Адрес доставки или кафе"),
          ),
        ],
      ),
    );
    return CartIsEmpty();
  }
}
