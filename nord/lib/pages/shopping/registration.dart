import 'package:flutter/material.dart';
import '../../components/components.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Оформление заказа'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AddressTile2(),
          ListTile(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const Text('a');
                },
              );
            },
            leading: Image.asset('assets/Illustration-Colored-Clocks.png'),
            title: Text(
              "Заберу",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            subtitle: Text(
              "В ближайшее время",
              style: TextStyle(
                color: Colors.red[900],
                fontSize: 16,
              ),
            ),
            trailing: Image.asset('assets/Icon-Expand-More.png'),
          ),
          Text('Способы оплаты'),
          TextField(),
          ElevatedButton(onPressed: () {}, child: Text('Оплатить')),
        ],
      ),
    );
  }
}
