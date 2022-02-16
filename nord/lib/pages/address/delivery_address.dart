import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';

import '../../components/gradient_button.dart';
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
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Colors.red[900],
            )),
        title: const Text('Адреса доставки'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Домашний адрес'),
            subtitle: Text('Дачный проспект, 36к3, квартира 410'),
            trailing: Icon(
              SeverMetropol.Icon_Edit,
              color: Colors.red[900],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GradientButton(
              child: Text('Добавить новый адрес'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddressPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
