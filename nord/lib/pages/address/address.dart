import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Адрес доставки или кафе'),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text('Выбрать'),
          onPressed: () {},
        ),
      ),
    );
  }
}
