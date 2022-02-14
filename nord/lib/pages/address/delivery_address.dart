import 'package:flutter/material.dart';
import 'address.dart';

class DeliveryAddressPage extends StatelessWidget {
  const DeliveryAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
        title: const Text('Адреса доставки'),
      ),
      body: Container(
        child: ElevatedButton(
          // ignore: prefer_const_constructors
          child: Text('Добавить адрес'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddressPage()));
          },
        ),
      ),
    );
  }
}
